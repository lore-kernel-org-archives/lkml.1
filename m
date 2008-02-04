Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYBDTBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYBDTBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYBDTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:01:36 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:42604 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754887AbYBDTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:01:36 -0500
Message-ID: <47A76106.3000103@gandalf.sssup.it>
Date: Mon, 04 Feb 2008 20:01:26 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it>	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	<47A051A7.7030004@gandalf.sssup.it>	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	<47A09723.7020000@gandalf.sssup.it>	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	<47A12A2E.5040309@gandalf.sssup.it> <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> Haavard
>
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 477950f..c61fcc3 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -337,9 +337,12 @@ atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
>  	struct circ_buf *ring = &atmel_port->rx_ring;
>  	struct atmel_uart_char *c;
>  
> -	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE))
> +	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE)) {
> +		dev_err(port->dev, "RX ring buffer full, dropping data\n");
> +
>  		/* Buffer overflow, ignore char */
>  		return;
> +	}
>  
>  	c = &((struct atmel_uart_char *)ring->buf)[ring->head];
>  	c->status	= status;
>
>   

I have already tried that but I have never seen the buffer full. So 
tomorrow  I can do other
tests with the serial device. I think the the atmel_interrupt handler 
must check the
pass_counter before return IRQ_HANDLED.

Regards Michael


