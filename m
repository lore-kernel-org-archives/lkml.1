Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZKOUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZKOUkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 15:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZKOUkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 15:40:23 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48053 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbZKOUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 15:40:22 -0500
Date: Sun, 15 Nov 2009 21:40:25 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
In-Reply-To: <1258313031.21668.73.camel@Joe-Laptop.home>
Message-ID: <Pine.LNX.4.64.0911152139020.30372@ask.diku.dk>
References: <1258249925.16857.198.camel@Joe-Laptop.home>  <20091115065958.GA2459@hack>
 <20091115081126.GD15432@elte.hu>  <1258273714.21668.13.camel@Joe-Laptop.home>
  <20091115083951.GA27393@elte.hu> <m1hbswm7dk.fsf@fess.ebiederm.org> 
 <20091115103307.GB24931@elte.hu>  <1258306299.21668.30.camel@Joe-Laptop.home>
  <Pine.LNX.4.64.0911151916100.27042@ask.diku.dk> <1258313031.21668.73.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009, Joe Perches wrote:

> On Sun, 2009-11-15 at 19:20 +0100, Julia Lawall wrote:
> > Searching for things that are declared as functions (either a definition 
> > or a prototype), and then referenced as &f gives over 2000 results in 
> > almost 600 files.
> 
> Just curious, do you know how many are referenced
> without the &?

I got over 95000 (not checked in detail, though).

> > Here are a couple of typical examples:
> > 
> > arch/arm/mach-omap1/clock.c:
> > 
> > static const struct clkops clkops_dspck = {
> >        .enable         = &omap1_clk_enable_dsp_domain,
> >        .disable        = &omap1_clk_disable_dsp_domain,
> >  };
> > 
> > arch/arm/mach-omap1/serial.c:
> > 
> >        ret = request_irq(gpio_to_irq(gpio_nr), &omap_serial_wake_interrupt,
> >                           IRQF_TRIGGER_RISING, "serial wakeup", NULL);
> > 
> > Should both cases lose the initial &?
> 
> If what is desired is kernel wide consistent use, yes.
> What I would like is file/subsystem consistent use.
> 
> Looking at sysctl.c and seeing that different use
> stand out was odd.

It would be possible to count the number of occurrences in a given file, 
and then change the ones that have the less popular format, or a format 
that occurs less than some percentage of time.

julia
