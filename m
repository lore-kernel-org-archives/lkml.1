Return-Path: <linux-kernel-owner+w=401wt.eu-S1763134AbXHDHzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763134AbXHDHzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 03:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbXHDHy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 03:54:59 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:44162 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755751AbXHDHy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 03:54:59 -0400
X-Trace: 609996128-mk-filter-3.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.86.225
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAK/Ns0ZRAVbh/2dsb2JhbACBUQ
Subject: Re: [PATCH] SH: add machine-ops and Dreamcast specific fix-up
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
In-Reply-To: <20070804030624.GA20847@linux-sh.org>
References: <8b67d60708031226m747f142sd3ed4447fb896a94@mail.gmail.com>
	 <20070804030624.GA20847@linux-sh.org>
Content-Type: text/plain
Date: Sat, 04 Aug 2007 08:54:36 +0100
Message-Id: <1186214076.6302.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 12:06 +0900, Paul Mundt wrote:
> On Fri, Aug 03, 2007 at 08:26:17PM +0100, Adrian McMenamin wrote:
> > diff --git a/arch/sh/boards/dreamcast/Makefile
> > b/arch/sh/boards/dreamcast/Makefile
> > index e6fcd3d..7b97546 100644
> > --- a/arch/sh/boards/dreamcast/Makefile
> > +++ b/arch/sh/boards/dreamcast/Makefile
> > @@ -2,5 +2,5 @@
> >  # Makefile for the Sega Dreamcast specific parts of the kernel
> >  #
> > 
> > -obj-y	 := setup.o irq.o rtc.o reboot.o
> > +obj-y	 := setup.o irq.o rtc.o
> > 
> 
> You've created this diff against a bogus kernel.

True. My apologies - I missed that.

> 
> > diff --git a/arch/sh/kernel/Makefile b/arch/sh/kernel/Makefile
> > index bdb30ba..7ab2359 100644
> > --- a/arch/sh/kernel/Makefile
> > +++ b/arch/sh/kernel/Makefile

....

> > 
> >  void machine_crash_shutdown(struct pt_regs *regs)
> >  {
> 
> You've missed machine_crash_shutdown().
> 

Apologies - though I am a bit puzzled as why the code compiled and
linked with the two definitions, but that's not much of an excuse.


> > +static void mach_reboot_fixups(void)
> > +{
> > +	if (mach_is_dreamcast()) {
> > +		writel(0x00007611, 0xA05F6890);
> > +	}
> > +}
> > +
> Whether it's only the dreamcast or not is irrelevant, why bother adding
> abstraction if you intend to add pointless hacks that completely
> side-steps it?
> 

I don't understand the point you are trying to make. Please explain with
more clarity. What have I completely side stepped? I have followed,
broadly, the same pattern used in i386. Just that there, afaics, they
pick up on various PCI cards as the basis on which to modify the reboot.


> > diff --git a/include/asm-sh/emergency-restart.h
> > b/include/asm-sh/emergency-restart.h
> > index 108d8c4..d6bec92 100644
> > --- a/include/asm-sh/emergency-restart.h
> > +++ b/include/asm-sh/emergency-restart.h
> > @@ -1,6 +1,6 @@
> > -#ifndef _ASM_EMERGENCY_RESTART_H
> > -#define _ASM_EMERGENCY_RESTART_H
> > +#ifndef _ASM_SH_EMERGENCY_RESTART_H
> > +#define _ASM_SH_EMERGENCY_RESTART_H
> > 
> > -#include <asm-generic/emergency-restart.h>
> > +extern void machine_emergency_restart(void);
> > 
> > -#endif /* _ASM_EMERGENCY_RESTART_H */
> > +#endif /* _ASM_SH_EMERGENCY_RESTART_H */
> > 
> Pointless. Separating out machine_emergency_restart() buys us nothing,
> leave this alone and just kill it off from the machine_ops entirely.
> You've also ignored my earlier mail where I suggested this and killing
> off some of the other ops we had no use for (as well as consolidating
> machine_crash_shutdown()). I do wish you would read these things and wait
> until there's been a resolution one way or another.

I haven't ignored it. It was just explained with your customary
clarity :)


