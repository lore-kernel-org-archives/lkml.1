Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZKOTXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZKOTXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 14:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZKOTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 14:23:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1076 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZKOTXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 14:23:47 -0500
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0911151916100.27042@ask.diku.dk>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	 <20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	 <1258273714.21668.13.camel@Joe-Laptop.home>
	 <20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org>
	 <20091115103307.GB24931@elte.hu>
	 <1258306299.21668.30.camel@Joe-Laptop.home>
	 <Pine.LNX.4.64.0911151916100.27042@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Nov 2009 11:23:51 -0800
Message-ID: <1258313031.21668.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 19:20 +0100, Julia Lawall wrote:
> Searching for things that are declared as functions (either a definition 
> or a prototype), and then referenced as &f gives over 2000 results in 
> almost 600 files.

Just curious, do you know how many are referenced
without the &?

> Here are a couple of typical examples:
> 
> arch/arm/mach-omap1/clock.c:
> 
> static const struct clkops clkops_dspck = {
>        .enable         = &omap1_clk_enable_dsp_domain,
>        .disable        = &omap1_clk_disable_dsp_domain,
>  };
> 
> arch/arm/mach-omap1/serial.c:
> 
>        ret = request_irq(gpio_to_irq(gpio_nr), &omap_serial_wake_interrupt,
>                           IRQF_TRIGGER_RISING, "serial wakeup", NULL);
> 
> Should both cases lose the initial &?

If what is desired is kernel wide consistent use, yes.
What I would like is file/subsystem consistent use.

Looking at sysctl.c and seeing that different use
stand out was odd.

