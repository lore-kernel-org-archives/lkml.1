Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbXIZSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbXIZSvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXIZSvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:51:09 -0400
Received: from www.osadl.org ([213.239.205.134]:56630 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755406AbXIZSvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:51:08 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709261725.49662.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709252328.54843.rjw@sisk.pl> <1190755493.17409.72.camel@chaos>
	 <200709261725.49662.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 20:51:05 +0200
Message-Id: <1190832665.23376.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 17:25 +0200, Rafael J. Wysocki wrote:
> There still are some oddities.
> 
> First, with the "x86-64: Disable local APIC timer use on AMD systems with C1E"
> patch and my collection of suspend patches applied, the box doesn't boot
> (the suspend patches don't even thouch the boot code, so they should be
> irrelevant here).  However, it boots if patch-2.6.23-rc7-hrt1.patch (adjusted
> for 2.6.23-rc8) is applied in addition.  Is this expected?

No. That's odd. It is nothing else than adding "noapictimer" to the
kernel command line.

> Next, on 2.6.23-rc8 with the patches from:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc8/patches/
> 
> plus the "x86-64: Disable local APIC timer use on AMD systems with C1E" patch
> and patch-2.6.23-rc7-hrt1.patch (adjusted for 2.6.23-rc8), hibernation doesn't
> work correctly.  Although the box hibernates and restores, there is a temporary
> "hang" during the "resume hardware" sequence, after which the "lock" led starts
> to blink (and remains in this state) and something like this appears in dmesg:
> 
> Extended CMOS year: 2000
> Enabling non-boot CPUs ...
> SMP alternatives: switching to SMP code
> Booting processor 1/2 APIC 0x1
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 3990.36 BogoMIPS (lpj=7980735)
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> Unable to handle kernel paging request at ffffffff806c64d4 RIP: 
>  [<ffffffff802104cb>] identify_cpu+0x2ac/0x5a1

Hmm. That's really early in the CPU bring up. The only change in this
area is the C1E patch. Can you decode the exact source line, where it is
failing ?

	tglx



