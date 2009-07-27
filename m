Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbZG0OXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbZG0OXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZG0OXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:23:18 -0400
Received: from relay.atmel.no ([80.232.32.139]:56522 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZG0OXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:23:17 -0400
Date: Mon, 27 Jul 2009 16:23:12 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Albin Tonnerre <albin.tonnerre@gmail.com>
Cc: avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Add poll_get_char and poll_put_char uart_ops to
 atmel_serial.
Message-ID: <20090727162312.35c2f9d4@hskinnemoen-d830>
In-Reply-To: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <1246352745-31323-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added AT91 maintainers to Cc]

Albin Tonnerre wrote:
> +#ifdef CONFIG_CONSOLE_POLL
> +static int atmel_poll_get_char(struct uart_port *port)
> +{
> +	struct atmel_uart_port *aup = to_atmel_uart_port(port);
> +
> +	while (!(readb(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_RXRDY))
> +		barrier();
> +
> +	return readb(aup->uart.membase + ATMEL_US_RHR);
> +}
> +
> +static void atmel_poll_put_char(struct uart_port *port, unsigned char ch)
> +{
> +	struct atmel_uart_port *aup = to_atmel_uart_port(port);
> +	unsigned int status;
> +
> +	while (!(readb(aup->uart.membase + ATMEL_US_CSR) & ATMEL_US_TXRDY))
> +		barrier();
> +
> +	writeb(ch, aup->uart.membase + ATMEL_US_THR);
> +}
> +#endif

All the registers are 32 bits wide, so you should use __raw_readl() and
__raw_writel() to avoid any endianness issues (AT91 is little endian
and AVR32 is big endian).

Haavard
