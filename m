Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZENK3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZENK3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZENK2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:28:51 -0400
Received: from india.einfochips.com ([203.88.139.151]:40231 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752948AbZENK2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:28:50 -0400
Message-ID: <4A0BF190.7030800@einfochips.com>
Date: Thu, 14 May 2009 15:55:20 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: alan@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gs: missing parentheses
References: <4A0BEE4C.30600@gmail.com>
In-Reply-To: <4A0BEE4C.30600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Roel Kluin wrote:
> `|' has a higher precedence than `?' so add parentheses.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/char/sx.c b/drivers/char/sx.c
> index 518f2a2..1f63add 100644
> --- a/drivers/char/sx.c
> +++ b/drivers/char/sx.c
> @@ -979,8 +979,8 @@ static int sx_set_real_termios(void *ptr)
>  			(I_IXANY(port->gs.port.tty) ? SP_TANY : 0) | SP_DCEN);
>  
>  	sx_write_channel_byte(port, hi_break,
> -			(I_IGNBRK(port->gs.port.tty) ? BR_IGN : 0 |
> -			I_BRKINT(port->gs.port.tty) ? BR_INT : 0));
>   
This looks correct to me.
> +			(I_IGNBRK(port->gs.port.tty) ? BR_IGN : 0) |
> +			(I_BRKINT(port->gs.port.tty) ? BR_INT : 0));
>   
It may not want Interrupt and Ignore both at the same time on received 
breaks.

>  
>  	sx_write_channel_byte(port, hi_txon, START_CHAR(port->gs.port.tty));
>  	sx_write_channel_byte(port, hi_rxon, START_CHAR(port->gs.port.tty));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> Email Scanned for Virus & Dangerous Content by : www.CleanMailGateway.com
>
>
>   
