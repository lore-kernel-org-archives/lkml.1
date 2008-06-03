Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYFCVXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYFCVXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYFCVXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:23:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbYFCVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:23:48 -0400
Date: Tue, 3 Jun 2008 14:23:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: wim@iguana.be, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: AT91SAM9/CAP9 watchdog driver
Message-Id: <20080603142316.c53b32b2.akpm@linux-foundation.org>
In-Reply-To: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
References: <cd73a99e0806010940g501f11b4jcb7caf6acfd5c49f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 18:40:46 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> +static int __init at91wdt_probe(struct platform_device *pdev)
> +{
> +	int res;
> +
> +	if (at91wdt_miscdev.parent)
> +		return -EBUSY;
> +	at91wdt_miscdev.parent = &pdev->dev;
> +
> +	res = misc_register(&at91wdt_miscdev);
> +	if (res)
> +		return res;
> +
> +	/* Set watchdog */
> +	if (at91_wdt_settimeout(wdt_timeout) == -EINVAL) {
> +		pr_info("at91sam9_wdt: timeout must be between 1 and %d.\n",
> +			WDT_MAX_TIME);

Would printk(KERN_ERR be more appropriate here?

> +		return 0;

That looks like the wrong return value?

> +	}
> +
> +	return 0;
> +}
