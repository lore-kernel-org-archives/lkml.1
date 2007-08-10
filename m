Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXHJHL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXHJHL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXHJHLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:11:52 -0400
Received: from www.osadl.org ([213.239.205.134]:48425 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbXHJHLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:11:51 -0400
From: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
Date: Fri, 10 Aug 2007 09:12:35 +0200
User-Agent: KMail/1.9.5
Cc: "Ulf Samuelsson" <ulf@atmel.com>, "Marc Pignat" <marc.pignat@hevs.ch>,
       andrew@sanpeople.com, trivial@kernel.org, linux-kernel@vger.kernel.org,
       Andy Herzig <andrew.herzig@ngc.com>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com> <200708091801.20077.marc.pignat@hevs.ch> <018a01c7dad3$10ca8190$dcc4af0a@atmel.com>
In-Reply-To: <018a01c7dad3$10ca8190$dcc4af0a@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708100912.35485.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 10 August 2007 00:15 schrieb Ulf Samuelsson:
> 
> > > +#if defined(CONFIG_ARCH_AT91RM9200)
> > >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > > self-refresh mode */
> 
> > Why don't use:
> > if (cpu_is_at91rm9200())
> > at91_sys_write(AT91_SDRAMC_SRR, 1);
> 
> What is the benefit?
> Will the optimizer remove the code if the CPU is not the at91rm9200?

No, it won't. cpu_is_something() is intended for runtime decisions.
Remember that the purpose of this patch was to solve a compile time
issue (see subject). AT91_SDRAMC_SRR isn't defined properly for
non-9200 processors because they don't have that register. So we need
something like #ifdef to include this line only on 9200.

Hans
