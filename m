Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXIZTf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXIZTf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbXIZTft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:35:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40126 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbXIZTfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:35:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Wed, 26 Sep 2007 21:49:54 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709261725.49662.rjw@sisk.pl> <1190832665.23376.38.camel@chaos>
In-Reply-To: <1190832665.23376.38.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709262149.54732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 September 2007 20:51, Thomas Gleixner wrote:
> On Wed, 2007-09-26 at 17:25 +0200, Rafael J. Wysocki wrote:
> > There still are some oddities.
> > 
> > First, with the "x86-64: Disable local APIC timer use on AMD systems with C1E"
> > patch and my collection of suspend patches applied, the box doesn't boot
> > (the suspend patches don't even thouch the boot code, so they should be
> > irrelevant here).  However, it boots if patch-2.6.23-rc7-hrt1.patch (adjusted
> > for 2.6.23-rc8) is applied in addition.  Is this expected?
> 
> No. That's odd. It is nothing else than adding "noapictimer" to the
> kernel command line.

Seems to be reproducible, though.  I'll investigate further.

> > Next, on 2.6.23-rc8 with the patches from:
> > 
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc8/patches/
> > 
> > plus the "x86-64: Disable local APIC timer use on AMD systems with C1E" patch
> > and patch-2.6.23-rc7-hrt1.patch (adjusted for 2.6.23-rc8), hibernation doesn't
> > work correctly.  Although the box hibernates and restores, there is a temporary
> > "hang" during the "resume hardware" sequence, after which the "lock" led starts
> > to blink (and remains in this state) and something like this appears in dmesg:
> > 
> > Extended CMOS year: 2000
> > Enabling non-boot CPUs ...
> > SMP alternatives: switching to SMP code
> > Booting processor 1/2 APIC 0x1
> > Initializing CPU#1
> > Calibrating delay using timer specific routine.. 3990.36 BogoMIPS (lpj=7980735)
> > CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > CPU: L2 Cache: 512K (64 bytes/line)
> > Unable to handle kernel paging request at ffffffff806c64d4 RIP: 
> >  [<ffffffff802104cb>] identify_cpu+0x2ac/0x5a1
> 
> Hmm. That's really early in the CPU bring up. The only change in this
> area is the C1E patch. Can you decode the exact source line, where it is
> failing ?

Yes, I can, but I'll first see what's wrong with the boot.

Greetings,
Rafael
