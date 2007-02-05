Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXBEKdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXBEKdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbXBEKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:33:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33519 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751434AbXBEKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:33:43 -0500
Date: Mon, 5 Feb 2007 10:46:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Wu, Bryan" <Bryan.Wu@analog.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH 2/3] Blackfin: serial driver for Blackfin architecture
 against Linux kernel 2.6.20
Message-ID: <20070205104619.72cfd914@localhost.localdomain>
In-Reply-To: <D3664A3D9376A94BB603EE19E4AA246D10D64760@nwd2exm4.ad.analog.com>
References: <D3664A3D9376A94BB603EE19E4AA246D10D64760@nwd2exm4.ad.analog.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007 02:33:47 -0500
"Wu, Bryan" <Bryan.Wu@analog.com> wrote:

> 
> Hi everyone,
> 
> This is the serial driver supports Blackfin processors. It is designed
> for the serial core framework.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>

> +
> +#ifdef CONFIG_SERIAL_BFIN_PIO
> +static void local_put_char(struct bfin_serial_port *uart, char ch)
> +{
> +	unsigned short status;
> +	int flags = 0;
> +
> +	local_irq_save(flags);
> +
> +	do {
> +		status = UART_GET_LSR(uart);
> +	} while (!(status & THRE));
> +
> +	UART_PUT_CHAR(uart, ch);
> +
> +	local_irq_restore(flags);

Should this not be using the spinlock like the other stuff rather than
local_irq_* ??

> +}
> +
> +static void
> +bfin_serial_rx_chars(struct bfin_serial_port *uart)

(trivial) Formatting - function name on same line as type

 +	local_irq_save(flags);

Likewise - why this not locks ?


Other than the locking bits looks ok, although has rather a lot of ifdefs
