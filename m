Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbZEAMhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbZEAMhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZEAMhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:37:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58467 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZEAMho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:37:44 -0400
Date: Fri, 1 May 2009 13:37:28 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Message-ID: <20090501123728.GC27799@flint.arm.linux.org.uk>
Mail-Followup-To: Michal Simek <monstr@monstr.eu>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	Remis Lima Baima <remis.developer@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <10b3a32656e5552458db7412ef9ff8530d5f92aa.1241105648.git.arnd@arndb.de> <c1a198be0904302309w4154f97dqddd0b2df1924a821@mail.gmail.com> <200905011422.29753.arnd@arndb.de> <49FAEA2A.50504@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FAEA2A.50504@monstr.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 02:25:14PM +0200, Michal Simek wrote:
> Arnd Bergmann wrote:
> > On Friday 01 May 2009, Michal Simek wrote:
> >>> +/*
> >>> + * CLOCK_TICK_RATE is highly PC-specific and should not
> >>> + * be used in portable code. 1193182 is the value for the
> >>> + * original i8253 PIC.
> >>> + */
> >>> +#ifndef CLOCK_TICK_RATE
> >>> +#define CLOCK_TICK_RATE                1193182
> >>> +#endif
> >>
> >> Why is this in generic code?
> > 
> > CLOCK_TICK_RATE is only used in a few places:
> > 
> > drivers/char/vt_ioctl.c:                        arg = CLOCK_TICK_RATE / arg;
> > drivers/char/vt_ioctl.c:                        count = CLOCK_TICK_RATE / count;
> > drivers/clocksource/acpi_pm.c:  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
> > drivers/input/joystick/analog.c:#define DELTA(x,y)      (cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? CLOCK_TICK_RATE / HZ : 0
> > drivers/rtc/rtc-pxa.c:#define TIMER_FREQ                CLOCK_TICK_RATE
> > drivers/serial/serial_ks8695.c:         .uartclk        = CLOCK_TICK_RATE * 16,
> > drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
> > drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
> > drivers/watchdog/ks8695_wdt.c:  unsigned long tval = wdt_time * CLOCK_TICK_RATE;
> > include/linux/jiffies.h:#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)  /* For divider */
> > include/linux/jiffies.h:#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
> > include/linux/timex.h: *        Moved CLOCK_TICK_RATE, CLOCK_TICK_FACTOR and FINETUNE to asm/timex.h
> > sound/oss/pas2_pcm.c:           foo = ((CLOCK_TICK_RATE / 2) + (arg / 2)) / arg;
> > sound/oss/pas2_pcm.c:           arg = ((CLOCK_TICK_RATE / 2) + (foo / 2)) / foo;
> > sound/oss/pas2_pcm.c:           foo = (CLOCK_TICK_RATE + (arg / 2)) / arg;
> > sound/oss/pas2_pcm.c:           arg = (CLOCK_TICK_RATE + (foo / 2)) / foo;
> > 
> > All of these are either PC-specific, or they don't actually care
> > about the specific value. Most architectures just use the
> > value from the IBM PC, so we might as well make that the generic
> > default.
> 
> ok. Let's move out from arch to generic location.

That's only possible once the users have been fixed - otherwise the ARM
stuff listed above _will_ break.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
