Return-Path: <linux-kernel-owner+w=401wt.eu-S967022AbXFGXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967022AbXFGXNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965902AbXFGXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:13:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764758AbXFGXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:13:38 -0400
Date: Thu, 7 Jun 2007 16:09:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/1] Watchdog driver for AT32AP700X devices
Message-Id: <20070607160910.34d64842.akpm@linux-foundation.org>
In-Reply-To: <1181138647434-git-send-email-hcegtvedt@atmel.com>
References: <1181138647434-git-send-email-hcegtvedt@atmel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jun 2007 16:04:07 +0200
Hans-Christian Egtvedt <hcegtvedt@atmel.com> wrote:

> This patch adds support for the built in watchdog in AT32AP700X devices.
> 
> Tested on AT32AP7000 and ATSTK1000.
> 
> Hardware documentation can be found in the AT32AP7000 datasheet.
> 
> ...
>
> +static int __init at32_wdt_probe(struct platform_device *pdev)
> +{
> +	struct resource	*regs;
> +	int ret;
> +
> +	if (wdt) {
> +		dev_dbg(&pdev->dev, "only 1 wdt instance supported.\n");
> +		return -EBUSY;
> +	}
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs) {
> +		dev_dbg(&pdev->dev, "missing mmio resource\n");
> +		return -ENXIO;
> +	}
> +
> +	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
> +	if (!wdt) {
> +		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
> +		return -ENOMEM;
> +	}
> +
> +	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);

I see an ioremap(), but there are no iounmap()s anywhere.


