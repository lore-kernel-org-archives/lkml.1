Return-Path: <linux-kernel-owner+w=401wt.eu-S966632AbZLHWD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966632AbZLHWD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966623AbZLHWD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:03:28 -0500
Received: from mail.perches.com ([173.55.12.10]:1090 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966486AbZLHWD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:03:27 -0500
Subject: Re: GPIO support for HTC Dream
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
In-Reply-To: <20091208214658.GC4164@elf.ucw.cz>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <4B1EB57D.6070408@bluewatersys.com>  <20091208214658.GC4164@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 14:03:32 -0800
Message-ID: <1260309812.27677.117.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:46 +0100, Pavel Machek wrote:
> Add GPIO support for HTC Dream.

Hi Pavel.  Thanks for this.

Maybe it'd be nicer to use pr_<level> and add
#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
?

> +++ b/arch/arm/mach-msm/board-dream-gpio.c
> +static int dream_gpio_write(struct gpio_chip *chip, unsigned n, unsigned on)
[]
> +		printk(KERN_ERR "dream_gpio_write called on input %d\n", n);
		pr_err("called on input %d\n", n);
[]
> +static void dream_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
[]
> +			printk(KERN_ERR "dream_gpio_irq_handler: got masked "
			pr_err("got masked interrupt: %d:%02x\n"
> +++ b/arch/arm/mach-msm/generic_gpio.c
[]
> +int register_gpio_chip(struct gpio_chip *new_gpio_chip)
[]
> +		printk(KERN_ERR "register_gpio_chip: failed to allocate state\n");
		pr_err("failed to allocate state\n");
> +			printk(KERN_ERR "register_gpio_chip: failed to allocate array\n");
			pr_err("failed to allocate array\n");
[]
> +			printk(KERN_ERR "register_gpio_source %u-%u overlaps with %u-%u\n",
Wrong function name?
			pr_err("%u-%u overlaps with %u-%u\n",

