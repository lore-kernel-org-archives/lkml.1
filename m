Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973Ab0ALP7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0ALP7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114Ab0ALP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:59:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0ALP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:59:35 -0500
Date: Tue, 12 Jan 2010 16:59:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: x86@kernel.org, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] irq: handle irq0 special only on x86
Message-ID: <20100112155929.GA5615@pengutronix.de>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 09, 2009 at 10:20:01AM +0100, Uwe Kleine-König wrote:
> I just noticed this when digging in the irq handling.  At least for arm
> this doesn't make sense.  Not sure if x86 is the only arch this test
> is valid for, but probably it is.
... so I added linux-arch@vger.kernel.org
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  kernel/irq/spurious.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> index 22b0a6e..4996b66 100644
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -199,8 +199,10 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
>  	if (irqfixup < 2)
>  		return 0;
>  
> +#if defined(CONFIG_ARCH_X86)
>  	if (!irq)
>  		return 1;
> +#endif
>  
>  	/*
>  	 * Since we don't get the descriptor lock, "action" can
the feed-back I have got up to now wasn't helpfull.  (Only some "irq0 is
evil---no it's not" discussion.) So what do you think?  I admit the
#ifdef isn't nice, but if the semantic is OK I'm willing to rework it
into something more pretty.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
