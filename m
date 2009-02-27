Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZB0PAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZB0PAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZB0O76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:59:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48153 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754737AbZB0O75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:59:57 -0500
Date: Fri, 27 Feb 2009 09:59:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <alpine.LFD.2.00.0902262039320.3111@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Linus Torvalds wrote:

> On Thu, 26 Feb 2009, Alan Stern wrote:
> > 
> > What you're missing is that the embedded world is quite a large one.  
> 
> I'm gpoing to give you one more clue, and if you don't stop sending out 
> these IDIOTIC emails, I'm going to put you into my killfile.
> 
> Got it?

Whoa!!  Hold on there!  You got too angry too quickly.  I'm Alan Stern, 
not Arve Hjønnevåg; that was the first email I've sent on this topic.

And while perhaps it was idiotic, you shouldn't put the blame for it on 
Arve.

> So listen up:
>  - the number of ARM chips sold doesn't matter one F*CKING WHIT.
>  - You need to add ONE SINGLE "sysdev" entry for ARM to take care of this 
>    FOR EVERY DAMN SINGLE ONE.
>  - Your inane whining about this AFTER I HAVE TOLD YOU MULTIPLE TIMES HOW 
>    TO DO IT, AND AFTER I HAVE TOLD YOU THAT IT'S A SPECIAL CASE, IS 
>    F*CKING IRRITATING.
> 
> Got it?
> 
> I _grepped_ for that enable_irq_wake() use. It looks like it's only used 
> on ARM and maybe BF. Add the five lines of code (just cut and paste them 
> from my earlier email) to your architecture already, AND STOP WHINING.

Really?  Let's see (this is using Greg KH's development tree):

$ find . -name '*.[ch]' | xargs grep enable_irq_wake
./drivers/serial/serial_core.c:         enable_irq_wake(port->irq);
./drivers/usb/gadget/at91_udc.c:                enable_irq_wake(udc->udp_irq);
./drivers/usb/gadget/at91_udc.c:                enable_irq_wake(udc->board.vbus_pin);
./drivers/usb/musb/musb_core.c: if (enable_irq_wake(nIrq) == 0) {
./drivers/usb/host/ohci-at91.c:         enable_irq_wake(hcd->irq);
./drivers/input/serio/sa1111ps2.c:      enable_irq_wake(ps2if->dev->irq[0]);
./drivers/input/keyboard/gpio_keys.c:                           enable_irq_wake(irq);
./drivers/input/keyboard/pxa27x_keypad.c:               enable_irq_wake(keypad->irq);
./drivers/input/keyboard/bf54x-keys.c:          enable_irq_wake(bf54x_kpad->irq);
./drivers/pcmcia/at91_cf.c:             enable_irq_wake(board->det_pin);
./drivers/pcmcia/at91_cf.c:                     enable_irq_wake(board->irq_pin);
./drivers/mmc/host/at91_mci.c:          enable_irq_wake(host->board->det_pin);
./drivers/mfd/htc-egpio.c:              enable_irq_wake(ei->chained_irq);
./drivers/mfd/pcf50633-core.c:  if (enable_irq_wake(client->irq) < 0)
./drivers/rtc/rtc-sa1100.c:             enable_irq_wake(IRQ_RTCAlrm);
./drivers/rtc/rtc-omap.c:               enable_irq_wake(omap_rtc_alarm);
./drivers/rtc/rtc-s3c.c:                enable_irq_wake(s3c_rtc_alarmno);
./drivers/rtc/rtc-at91rm9200.c:                 enable_irq_wake(AT91_ID_SYS);
./drivers/rtc/rtc-cmos.c:                       enable_irq_wake(cmos->irq);
./drivers/rtc/rtc-bfin.c:               enable_irq_wake(IRQ_RTC);
./drivers/rtc/rtc-ds1374.c:             enable_irq_wake(client->irq);
./drivers/rtc/rtc-at91sam9.c:                   enable_irq_wake(AT91_ID_SYS);
./drivers/rtc/rtc-pxa.c:                enable_irq_wake(pxa_rtc->irq_Alrm);
./drivers/power/pda_power.c:                    ac_wakeup_enabled = !enable_irq_wake(ac_irq->start);
./drivers/power/pda_power.c:                    usb_wakeup_enabled = !enable_irq_wake(usb_irq->start);
./arch/arm/mach-sa1100/neponset.c:      enable_irq_wake(IRQ_GPIO25);
./arch/arm/mach-s3c2410/mach-amlm5900.c:                enable_irq_wake(IRQ_EINT9);
./arch/arm/mach-omap1/board-osk.c:                      enable_irq_wake(irq);
./arch/arm/mach-omap1/serial.c: enable_irq_wake(gpio_to_irq(gpio_nr));
./arch/arm/plat-omap/gpio.c:                    enable_irq_wake(bank->irq);
./arch/arm/plat-omap/gpio.c:                    enable_irq_wake(bank->irq);
./arch/arm/plat-omap/gpio.c:/* Use disable_irq_wake() and enable_irq_wake() functions from drivers */
./include/linux/interrupt.h:static inline int enable_irq_wake(unsigned int irq)
./include/linux/interrupt.h:static inline int enable_irq_wake(unsigned int irq)

Perhaps these aren't all the sort of usage you're talking about, but I
bet most of them are.  It certainly looks like more than just ARM.  
Maybe not all that much more, but definitely more.  And the number will
only grow in the future.

> It's not a generic case. It's not a problem. You can damn well fix it in 
> the ONE SINGLE ARCHITECTURE (or maybe two) that cares. I've told you how.

I'm not arguing with your suggestion; I'm merely disagreeing with your 
statement that wakeup interrupts are "definitely not the normal case".

Alan Stern

