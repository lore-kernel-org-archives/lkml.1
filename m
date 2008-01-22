Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYAVQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYAVQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYAVQwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:52:45 -0500
Received: from mail.hevs.ch ([153.109.23.15]:38918 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYAVQwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:52:44 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Date: Tue, 22 Jan 2008 17:52:43 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Victor <linux@maxim.org.za>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com> <1201013444-30370-6-git-send-email-hskinnemoen@atmel.com> <1201013444-30370-7-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1201013444-30370-7-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221752.43830.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I removed linux-arm-kernel@lists.arm.linux.org.uk from cc, it is a
subscriber-only list.

On Tuesday 22 January 2008, Haavard Skinnemoen wrote:
> From: Chip Coldwell <coldwell@redhat.com>
...
> @@ -47,6 +50,11 @@
>  
>  #include "atmel_serial.h"
>  
> +#define SUPPORT_PDC
> +#define PDC_BUFFER_SIZE		(L1_CACHE_BYTES << 3)
> +#warning "Revisit"
why add this warning?

...
> @@ -1090,7 +1434,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
>  	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
>  
>  	if (device_may_wakeup(&pdev->dev)
> -	    && !at91_suspend_entering_slow_clock())
> +		&& !clk_must_disable(atmel_port->clk))
1. this has nothing to do with dma
2. clk_must_disable isn't in mainline (2.6.24-rc8) for at91 (not verified for avr32).

CONFIG_MAGIC_SYSRQ isn't working with this pach, (CONFIG_MAGIC_SYSRQ has never
worked with atmel_serial dma patches).

For me breaking CONFIG_MAGIC_SYSRQ is not a critical regression and can be
fixed later, but the "clk_must_disable" problem breaks compilation.

Regards

Marc
