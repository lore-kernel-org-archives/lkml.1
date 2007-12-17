Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXLQQtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXLQQtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbXLQQtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:49:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbXLQQtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:49:04 -0500
Date: Mon, 17 Dec 2007 17:48:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217164832.GA13353@elte.hu>
References: <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217161243.05c32df4@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> I don't think we should be offering udelay based delays at this point. 
> There are a lot of drivers to fix first. This is just one trivial 
> example
> 
> ...
> 
> --- drivers/watchdog/wdt.c~	2007-12-17 15:58:49.000000000 +0000
> +++ drivers/watchdog/wdt.c	2007-12-17 15:58:49.000000000 +0000
> @@ -70,6 +70,8 @@
>  static int io=0x240;
>  static int irq=11;
>  
> +static DEFINE_SPINLOCK(wdt_lock);
> +
>  module_param(io, int, 0);
>  MODULE_PARM_DESC(io, "WDT io port (default=0x240)");
>  module_param(irq, int, 0);
> @@ -109,6 +111,8 @@
>  
>  static int wdt_start(void)
>  {
> +	unsigned long flags;
> +	spin_lock_irqsave(&wdt_lock, flags);
>  	inb_p(WDT_DC);			/* Disable watchdog */
>  	wdt_ctr_mode(0,3);		/* Program CTR0 for Mode 3:

a really stupid question, in what way does:

  inb_p(WDT_DC);

work better than:

  inb(WDT_DC);
  delay(2);

?

(i'm not suggesting you are wrong, this detail just fails to click at 
the moment.)

	Ingo
