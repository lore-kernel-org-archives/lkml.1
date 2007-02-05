Return-Path: <linux-kernel-owner+w=401wt.eu-S933491AbXBEVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbXBEVs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933486AbXBEVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:48:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42534 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933478AbXBEVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:48:26 -0500
Date: Mon, 5 Feb 2007 21:59:01 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] serial driver PMC MSP71xx, kernel linux-mips.git master
Message-ID: <20070205215901.7344c954@localhost.localdomain>
In-Reply-To: <45C77B61.1080209@pmc-sierra.com>
References: <45C77B61.1080209@pmc-sierra.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   	unsigned char		hub6;			/* this should be in the 8250 driver */
>   	unsigned char		unused[3];
> +	void				*data;			/* generic platform data pointer */
>   };

Convention is "private_data"

>
>   /*
> diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
> index 3c8a6aa..b3550cc 100644
> --- a/include/linux/serial_reg.h
> +++ b/include/linux/serial_reg.h
> @@ -37,6 +37,7 @@ #define UART_IIR_MSI		0x00 /* Modem stat
>   #define UART_IIR_THRI		0x02 /* Transmitter holding register empty */
>   #define UART_IIR_RDI		0x04 /* Receiver data interrupt */
>   #define UART_IIR_RLSI		0x06 /* Receiver line status interrupt */
> +#define UART_IIR_BUSY		0x07 /* DesignWare APB Busy Detect */

Please move this down a line to break it from "official" values and call
it DESIGNWARE_UART_IIR_BUSY, so it is obviously designware specific.

Otherwise looks much less invasive and messy
