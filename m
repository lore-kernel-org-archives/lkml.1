Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYAPNsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYAPNsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYAPNsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:48:13 -0500
Received: from www.tglx.de ([62.245.132.106]:58426 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbYAPNsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:48:12 -0500
Date: Wed, 16 Jan 2008 14:47:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: TSC && HPET calibration
In-Reply-To: <20080115021720.ad71605f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.99999.0801161446240.3764@localhost.localdomain>
References: <20080110123612.M81049@visp.net.lb> <20080115021720.ad71605f.akpm@linux-foundation.org>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, Andrew Morton wrote:
> On Thu, 10 Jan 2008 14:36:12 +0200 "Denys Fedoryshchenko" <denys@visp.net.lb> wrote:
> 
> > Hi
> > 
> > I have same issue, but it's never passed synchronization.
> > 
> > Jan 10 12:59:44 visp-1 Time: tsc clocksource has been installed.
> > Jan 10 13:41:51 visp-1 ACPI: HPET 000F29CD, 0038 (r1 DELL   PE_SC3          1 
> > DELL        1)
> > Jan 10 13:41:51 visp-1 ACPI: HPET id: 0x8086a201 base: 0xfed00000
> > Jan 10 13:41:51 visp-1 hpet clockevent registered
> > Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> > Jan 10 13:41:51 visp-1 checking TSC synchronization [CPU#0 -> CPU#2]:
> > Jan 10 13:41:51 visp-1 Measured 1020 cycles TSC warp between CPUs, turning 
> > off TSC clock.
> > Jan 10 13:41:51 visp-1 Marking TSC unstable due to: check_tsc_sync_source 
> > failed.
> > Jan 10 13:41:51 visp-1 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> > Jan 10 13:41:51 visp-1 hpet0: 3 64-bit timers, 14318180 Hz
> > Jan 10 13:41:51 visp-1 Time: hpet clocksource has been installed.
> > 
> > grep Measures
> > Sep 19 14:31:28 visp-1 Measured 1044 cycles TSC warp between CPUs, turning 
> > off TSC clock.
> > Sep 19 18:22:46 visp-1 Measured 996 cycles TSC warp between CPUs, turning off 
> > TSC clock.
> > Sep 19 18:35:44 visp-1 Measured 1080 cycles TSC warp between CPUs, turning 
> > off TSC clock.
> 
> Which kernel version?

That's not a kernel version problem.

The TSCs on the CPUs are not synchronized, which means we can observe
time going backwards when we read TSC on one and then on another CPU.
TSC is switched off due to this.

This is also unrelated to HPET. If there would be no HPET available we
would use some other clocksource instead. On this box we use HPET
because it's the best clocksource we have in the system.

Thanks,
        tglx
