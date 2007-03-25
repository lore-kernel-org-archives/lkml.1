Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXCYH37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXCYH37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 03:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXCYH37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 03:29:59 -0400
Received: from www.osadl.org ([213.239.205.134]:48982 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbXCYH36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 03:29:58 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070325071023.GL17532@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174679344.10840.334.camel@localhost.localdomain>
	 <20070325071023.GL17532@mellanox.co.il>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 09:37:26 +0200
Message-Id: <1174808247.10840.467.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 09:11 +0200, Michael S. Tsirkin wrote:
> > I lost track of Michaels various nested problems.
> > 
> > Michael can you please give a summary on _all_ entries in the
> > regressions list against Linus latest ?
> 
> I tested 2 different configurations on my T60:
> - With CONFIG_NO_HZ enabled.
>   I tested this on -rc1, and have not retested with CONFIG_NO_HZ since.
>   Observed behaviour: the system would not come out of suspend to RAM.
>   After I press Fn/F4 the crescent LED starts blinking so it seems Linux started
>   doing something.
>   This is a problem but not a regression as such, since CONFIG_NO_HZ is new
>   in 2.6.21.

It needs to be fixed before 2.6.21 final nevertheless.

> - Without CONFIG_NO_HZ
>   I last tested this with cd05a1f818073a623455a58e756c5b419fc98db9.
>   After systems comes out of suspend to ram, I observed the following
>   behaviour (I used s2ram from console):
>   1. The first disk access takes much longer than with 2.6.20
>   2. System clock does not advance (date always reports the same time)
>   3. After an attempt to switch to X, X starts drawing some windows and then hangs
> 
>   All 3 issues are new and did not occur under 2.6.20, so this is a regression.
>   Attached is a full dmesg from boot to resume.

There is not much interesting to see in the log.

Can you please test the following:

Add "clocksource=acpi_pm" to the kernel commandline.

If this does not change anything, then disable CONFIG_HPET and retry.


One thing in the log is indeed scary:

[    2.959150] Calibrating delay using timer specific routine.. 20089.12
BogoMIPS (lpj=100445639)

This is after the reboot, but it is not related to your problem. This is
a different problem, which needs urgent attention.

Adrian, can you open a seperate entry for this please ? It is not a new
thing, this can be observed with older kernels as well, but it needs to
be addressed. It probably needs a similar solution as I did for the
local apic timer calibration.

	tglx


