Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZG0AY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZG0AY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 20:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZG0AY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 20:24:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46957 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbZG0AYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 20:24:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ePRrDrkE8oB+S9tLNF3jtDPzBmu/n8HoYQuQWXyDfTgqJvRCnK8ewIgcP1ICMkSBP
	hWnTGQB7BLeJJSAAYCf5w==
Date: Sun, 26 Jul 2009 17:24:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <4A6CF220.7080605@lwfinger.net>
Message-ID: <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Larry Finger wrote:

> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
> > Subject		: Page allocation failures with b43 and p54usb
> > Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> > Date		: 2009-04-29 21:01 (89 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
> > 		  http://lkml.org/lkml/2009/6/7/136
> > Handled-By	: Johannes Berg <johannes@sipsolutions.net>
> 
> This bug was fixed by commit 781b2ba6eb5f22440afac9c79a89ebd6e3674a60
> entitled "SLUB: Out-of-memory diagnostics" by Pekka Enberg
> <penberg@cs.helsinki.fi> and dated Wed Jun 10 18:50:32 2009 +0300.
> 

Hmm, I'm remembering differently.  I thought the root problem here has 
only been fixed in Pekka's slab-2.6.git tree with "slub: add option to 
disable higher order debugging slabs" and isn't currently in Linus' tree.

> The fault occurred because when CONFIG_SLUB_DEBUG was set, many of the
> memory allocations for wireless buffers were increased from O(0) to
> O(1) causing memory fragmentation, and eventually there were no
> remaining O(1) fragments. This problem is unlikely to affect most
> users as none of the distos turn on the above debug option.
> 

It only happens when CONFIG_SLUB_DEBUG_ON is enabled for caches with 
sizes that increase as the result of the added metadata.
