Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZIOE7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZIOE7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZIOE7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:59:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZIOE7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:59:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=JJHBH8Mv+CUuReZAtdEtzZ5PqXlgUXFABcl+hxGH3OVuEIiF18PwDlYfe/unCaMEL
	GW43CRPMBnqnN/QUWqz4g==
Date: Mon, 14 Sep 2009 21:59:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaram <sureshjayaram@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: mmotm 2009-09-09-22-56 uploaded
In-Reply-To: <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0909142147220.30373@chino.kir.corp.google.com>
References: <200909100601.n8A61Eju002109@imap1.linux-foundation.org> <38c3c4860909132302j3fd7afe1p984b91d74eb1d782@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381004-747096607-1252990070=:30373"
Content-ID: <alpine.DEB.1.00.0909142147530.30373@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381004-747096607-1252990070=:30373
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.1.00.0909142147531.30373@chino.kir.corp.google.com>

On Mon, 14 Sep 2009, Suresh Jayaram wrote:

> Hi Andrew,
> 
> On Thu, Sep 10, 2009 at 11:31 AM, <akpm@linux-foundation.org> wrote:
> >
> > The mm-of-the-moment snapshot 2009-09-09-22-56 has been uploaded to
> >
> >   http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> >   git://git.zen-sources.org/zen/mmotm.git
> >
> 
> The current mmotm doesn't boot my T60p. It hangs (hardlock) very early
> during the boot after Uncompressing the kernel image. The last message
> I see on the screen is
> 
> "Probing EDD (edd=off to disable)...
> 
> Trying with edd=off didn't help. Other commandline options that didn't
> help include (acpi=off, noapic,nolapic,pci=no). It appears that it
> hardlocks during hardware detection.
> 
> Attached is my kernel config:
> 

There're a couple of known problems in booting the latest mmotm, 
2009-09-14-01-57, on T60p.

The first is passing a NULL pointer to a workqueue from 
clocksource_mark_unstable().  This is fixed by reverting 7285dd7 
"clocksource: Resolve cpu hotplug dead lock with TSC unstable" from the 
x86 timers/core tree; Martin's fix had no affect on this crash.

 [ I notice Thomas has since provided patches for this problem, so I'll 
   check if it solves this issue on T60p. ]

The second is an issue with the i8042 driver's laptop table not being NULL 
terminated.  This is fixed by Jin Dongming's patch at
http://marc.info/?l=linux-kernel&m=125263897713267.

The config you attached, however, is very different from 
mmotm-2009-09-14-01-57, so perhaps try this kernel with the above two 
fixes to see if you can successfully boot?
--531381004-747096607-1252990070=:30373--
