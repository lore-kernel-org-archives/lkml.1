Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZAMMLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZAMMLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZAMMLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:11:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56007 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757396AbZAMMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:11:18 -0500
Date: Tue, 13 Jan 2009 12:11:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       m.d.s.x.jonker@gmail.com
Subject: Re: [PATCH] serial: pnx8xxx_uart: Fix break signal handling
Message-ID: <20090113121135.5565b302@lxorguk.ukuu.org.uk>
In-Reply-To: <200901131109.n0DB9DRJ010712@pc67243907.ddns.nl-htc01.nxp.com>
References: <200901131109.n0DB9DRJ010712@pc67243907.ddns.nl-htc01.nxp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 12:09:13 +0100
"Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com> wrote:

> From: Mischa Jonker <mischa.jonker@nxp.com>
> 
> When a break signal is detected, the next character should be ignored.
> This was not implemented correctly for the pnx8xxx_uart driver.
> 
> Signed-off-by: Mischa Jonker <mischa.jonker@nxp.com>
> ---
> 
> diff --git a/drivers/serial/pnx8xxx_uart.c b/drivers/serial/pnx8xxx_uart.c
> index 22e30d2..1bb8f1b 100644
> --- a/drivers/serial/pnx8xxx_uart.c
> +++ b/drivers/serial/pnx8xxx_uart.c
> @@ -187,7 +187,7 @@ static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
>  	status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
>  		 ISTAT_TO_SM(serial_in(sport, PNX8XXX_ISTAT));
>  	while (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFIFO)) {
> -		ch = serial_in(sport, PNX8XXX_FIFO);
> +		ch = serial_in(sport, PNX8XXX_FIFO) & 0xff;

This appears to be unrelated.
