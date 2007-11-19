Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbXKSPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbXKSPmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXKSPmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:42:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43818 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXKSPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:42:10 -0500
Date: Mon, 19 Nov 2007 15:41:37 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 21285: Report baud rate back via termios
Message-ID: <20071119154137.GA30129@flint.arm.linux.org.uk>
References: <20071119151222.6cfa9c4c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119151222.6cfa9c4c@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 03:12:22PM +0000, Alan Cox wrote:
> Currently reports back the requested rate not the result of the divides
> but thats an easy fix for someone with h/w
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Ack for first hunk.  When can this be merged?  I assume it has to wait
for tty_encode_baud_rate() to appear in mainline?

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/21285.c linux-2.6.24-rc2-mm1/drivers/serial/21285.c
> --- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/21285.c	2007-11-16 17:20:48.000000000 +0000
> +++ linux-2.6.24-rc2-mm1/drivers/serial/21285.c	2007-11-16 18:35:29.000000000 +0000
> @@ -277,6 +279,8 @@
>  	if (termios->c_iflag & INPCK)
>  		port->read_status_mask |= RXSTAT_FRAME | RXSTAT_PARITY;
>  
> +	tty_encode_baud_rate(tty,  baud, baud);
> +
>  	/*
>  	 * Which character status flags should we ignore?
>  	 */
> @@ -301,6 +305,7 @@
>  	*CSR_UARTCON = 1;
>  
>  	spin_unlock_irqrestore(&port->lock, flags);
> +	
>  }
>  
>  static const char *serial21285_type(struct uart_port *port)

This hunk isn't required.

Note also that no one reads linux-arm@vger.kernel.org.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
