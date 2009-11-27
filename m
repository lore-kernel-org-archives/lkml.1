Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZK0OyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZK0OyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZK0OyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:54:22 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:13874 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbZK0OyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:54:21 -0500
Date: Fri, 27 Nov 2009 17:54:26 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091127145426.GA6135@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1259333060-24277-1-git-send-email-notasas@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 04:44:20PM +0200, Grazvydas Ignotas wrote:
> TWL4030/TPS65950 is a multi-function device with integrated charger,
> which allows charging from AC or USB. This driver enables the
> charger and provides several monitoring functions.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---

Thanks for the patch.

[...]
> +/*
> + * Attend to TWL4030 CHG_PRES (AC charger presence) events
> + */
> +static irqreturn_t twl4030_charger_interrupt(int irq, void *_di)
> +{
> +	struct twl4030_bci_device_info *di = _di;
> +
> +#ifdef CONFIG_LOCKDEP
> +	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> +	 * we don't want and can't tolerate.  Although it might be
> +	 * friendlier not to borrow this thread context...
> +	 */
> +	local_irq_enable();
> +#endif

Can you explain why the driver can't tolerate disabled irqs?
Calling schedule_delayed_work() from an irq context should be OK.

> +	schedule_delayed_work(&di->bat_work, msecs_to_jiffies(BCI_DELAY));
> +
> +	return IRQ_HANDLED;
> +}

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
