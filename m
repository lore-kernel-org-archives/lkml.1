Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXI1Udq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXI1Udq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXI1Udf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:33:35 -0400
Received: from www.osadl.org ([213.239.205.134]:50845 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755252AbXI1Ude (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:33:34 -0400
Subject: Re: [patch 0/2] suspend/resume regression fixes
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <46FD639D.9030301@rtr.ca>
References: <20070922220347.586903979@linutronix.de>
	 <alpine.LFD.0.999.0709221546250.16478@woody.linux-foundation.org>
	 <46FD639D.9030301@rtr.ca>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 22:33:30 +0200
Message-Id: <1191011610.18681.94.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 16:27 -0400, Mark Lord wrote:
> Linus Torvalds wrote:
> > 
> > On Sat, 22 Sep 2007, Thomas Gleixner wrote:
> >> My final enlightment was, when I removed the ACPI processor module,
> >> which controls the lower idle C-states, right before resume; this
> >> worked fine all the time even without all the workaround hacks.
> >>
> >> I really hope that this two patches finally set an end to the "jinxed
> >> VAIO heisenbug series", which started when we removed the periodic
> >> tick with the clockevents/dyntick patches.
> > 
> > Ok, so the patches look fine, but I somehow have this slight feeling that 
> > you gave up a bit too soon on the "*why* does this happen?" question.
> 
> On a closely related note:  I just now submitted a patch to fix SMP-poweroff,
> by having it do disable_nonboot_cpus before doing poweroff.
> 
> Which has led me to thinking..
> ..are similar precautions perhaps necessary for *all* ACPI BIOS calls?
> 
> Because one never knows what the other CPUs are doing at the same time,
> and what the side effects may be on the ACPI BIOS functions.
> 
> And also, I wonder if at a minimum we should be guaranteeing ACPI BIOS calls
> only ever happen from CPU#0 (or the "boot" CPU)?   Or do we do that already?

The ACPI calls are serialized in the kernel, AFAICT. But the fragile
situations (suspend, resume, shutdown, reboot) are probably those, where
some BIOS implementation expect that certain things are not called or
not active.

	tglx


