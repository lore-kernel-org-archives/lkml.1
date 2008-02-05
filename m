Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYBEM3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYBEM3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYBEM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:29:46 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:45485 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837AbYBEM3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:29:45 -0500
Message-ID: <47A856AF.5010202@gandalf.sssup.it>
Date: Tue, 05 Feb 2008 13:29:35 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it>	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	<47A051A7.7030004@gandalf.sssup.it>	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	<47A09723.7020000@gandalf.sssup.it>	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	<47A12A2E.5040309@gandalf.sssup.it>	<20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>	<47A76106.3000103@gandalf.sssup.it> <20080204212523.07a6da9e@siona>
In-Reply-To: <20080204212523.07a6da9e@siona>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index cb70cc5..f310a80 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -552,7 +552,7 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
>  		atmel_handle_transmit(port, pending);
>  	} while (pass_counter++ < ATMEL_ISR_PASS_LIMIT);
>  
> -	return IRQ_HANDLED;
> +	return pass_counter ? IRQ_HANDLED : IRQ_NONE;
>  }
>  
>  /*
>
>   
Just one question:
Receiving with hardware handshake works without PDC?

Regards Michael

