Return-Path: <linux-kernel-owner+w=401wt.eu-S939499AbXHJOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939499AbXHJOTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936452AbXHJOT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:19:28 -0400
Received: from imsc1.euromail.se ([217.174.79.93]:39801 "HELO
	garland.euromail.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S939358AbXHJOTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:19:24 -0400
Message-ID: <00a801c7db58$ed84d920$dcc4af0a@atmel.com>
From: "Ulf Samuelsson" <ulf@atmel.com>
To: "Marc Pignat" <marc.pignat@hevs.ch>,
       =?iso-8859-15?Q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Cc: <linux-arm-kernel@lists.arm.linux.org.uk>, <andrew@sanpeople.com>,
       <trivial@kernel.org>, <linux-kernel@vger.kernel.org>,
       "Andy Herzig" <andrew.herzig@ngc.com>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com> <018a01c7dad3$10ca8190$dcc4af0a@atmel.com> <200708100912.35485.hjk@linutronix.de> <200708100933.46235.marc.pignat@hevs.ch>
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Fri, 10 Aug 2007 15:54:50 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-OriginalArrivalTime: 10 Aug 2007 14:17:18.0913 (UTC) FILETIME=[28F5FB10:01C7DB59]
X-NAI-Spam-Score: -2.5
X-NAI-Spam-Report: 2 Rules triggered
	*  -2.5 -- BAYES_00 -- Bayesian spam probability is 0 to 1%
	*  0 -- HAS_X_HELO -- Mail contains HAS_X-HELO header
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Marc Pignat" <marc.pignat@hevs.ch>
To: "Hans-Jürgen Koch" <hjk@linutronix.de>
Cc: <linux-arm-kernel@lists.arm.linux.org.uk>; "Ulf Samuelsson" <ulf@atmel.com>; <andrew@sanpeople.com>; <trivial@kernel.org>; <linux-kernel@vger.kernel.org>; "Andy Herzig" <andrew.herzig@ngc.com>
Sent: Friday, August 10, 2007 9:33 AM
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x


On Friday 10 August 2007 09:12, Hans-Jürgen Koch wrote:
> Am Freitag 10 August 2007 00:15 schrieb Ulf Samuelsson:
> > 
> > > > +#if defined(CONFIG_ARCH_AT91RM9200)
> > > >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > > > self-refresh mode */
> > 
> > > Why don't use:
> > > if (cpu_is_at91rm9200())
> > > at91_sys_write(AT91_SDRAMC_SRR, 1);
> > 
> > What is the benefit?
More readable. (see '#ifdefs are ugly' in Documentation/SubmittingPatches)

> > Will the optimizer remove the code if the CPU is not the at91rm9200?
Optimizer will remove that code if at91rm9200 support is not compiled and 
choose at runtime if the cpu support is compiled in.

> 
> No, it won't. cpu_is_something() is intended for runtime decisions.
> Remember that the purpose of this patch was to solve a compile time
> issue (see subject). AT91_SDRAMC_SRR isn't defined properly for
> non-9200 processors because they don't have that register. So we need
> something like #ifdef to include this line only on 9200.
Oops, I missed that problem, sorry...

and what about this:
#ifdef CONFIG_ARCH_AT91RM9200
#define sdram_lowpower_enable() at91_sys_write(AT91_SDRAMC_SRR, 1)
#define sdram_lowpower_disable() at91_sys_write(AT91_SDRAMC_SRR, 0)
#else
#define sdram_lowpower_enable()
#define sdram_lowpower_disable()
#endif

and using sdram_lowpower_{enable,disable}() when requiered?

==> That is hiding the fact that the low power is not performed
        when it it not an AT91RM9200.
        I think the original approach is the best.

Best Regards
Ulf Samuelsson

