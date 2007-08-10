Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXHJHd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXHJHd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXHJHdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:33:47 -0400
Received: from mail.hevs.ch ([153.109.23.15]:43276 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbXHJHdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:33:46 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Fri, 10 Aug 2007 09:33:45 +0200
User-Agent: KMail/1.9.5
Cc: linux-arm-kernel@lists.arm.linux.org.uk, "Ulf Samuelsson" <ulf@atmel.com>,
       andrew@sanpeople.com, trivial@kernel.org, linux-kernel@vger.kernel.org,
       Andy Herzig <andrew.herzig@ngc.com>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com> <018a01c7dad3$10ca8190$dcc4af0a@atmel.com> <200708100912.35485.hjk@linutronix.de>
In-Reply-To: <200708100912.35485.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708100933.46235.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Regards

Marc
