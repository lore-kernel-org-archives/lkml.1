Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbZAQOq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbZAQOq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZAQOqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:46:20 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:43832 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856AbZAQOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:46:19 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.29-rc1: thinkpad problems during resume
Date: Sat, 17 Jan 2009 15:46:15 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
References: <20090113081316.GA2292@elf.ucw.cz> <b6a2187b0901130533m118e9401k8a7152d6f5982708@mail.gmail.com> <20090116104455.GA3283@elf.ucw.cz>
In-Reply-To: <20090116104455.GA3283@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901171546.15987.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 Januar 2009 schrieb Pavel Machek:
> Hi!
>
> > >> > Please let me know if that helped.
> > >>
> > >> I tested rc1+ these two reverts yesterday on my T61p. Doesnt work.
> > >> There must be at least one more patch that broke S2R on my thinkpad.
> > >> In fact, it is cpu hotplug that is broken (unplug works).
> > >
> > > I reproduced that: echo 0 > online works, echo 1 > online hangs. Will
> > > compile SMP-less kernel to verify that there are no more problems...

I made some progress on my T61p. git from yesterday + a revert of
commit e39ad415ac15116df213dfa2aa2a4f1b0857af9c
Author: Mike Travis <travis@sgi.com>
Date:   Sun Jan 4 05:18:10 2009 -0800

    cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs

makes cpu hotplug working again. Resume from suspend to ram is still broken on 
my Thinkpad. Looks like there is yet another patch to find....

Ingo, Mike: reverting e39ad415ac15116df213dfa2aa2a4f1b0857af9c fixes cpu 
hotplug on my thinkpad. Any idea how to proceed? Should we revert that patch 
in Linus git until we know what was wrong?
