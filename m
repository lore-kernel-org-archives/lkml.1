Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXLZWdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXLZWdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 17:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLZWde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 17:33:34 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58549 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638AbXLZWdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 17:33:33 -0500
Date: Wed, 26 Dec 2007 23:24:54 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ville Syrjala <syrjala@sci.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH] w1-gpio: Add GPIO w1 bus master driver
Message-ID: <20071226232454.039372b8@siona>
In-Reply-To: <1198222441690-git-send-email-syrjala@sci.fi>
References: <1198222441690-git-send-email-syrjala@sci.fi>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 09:34:01 +0200
Ville Syrjala <syrjala@sci.fi> wrote:

> +static struct platform_device foo_w1_device = {
> +	.name			= "w1-gpio",
> +	.id			= -1,

Assigning -1 to a u32 member isn't a very nice example. What does it
mean anyway?

> +static int __init w1_gpio_probe(struct platform_device *pdev)

This must be __devinit, or if you want to save a bit of memory...

> +	.probe	= w1_gpio_probe,

...remove this line, and...

> +static int __init w1_gpio_init(void)
> +{
> +	return platform_driver_register(&w1_gpio_driver);

...call platform_driver_probe(&w1_gpio_driver, w1_gpio_probe) here.

Haavard
