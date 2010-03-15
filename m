Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936117Ab0COKIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:08:22 -0400
Received: from av11-1-sn2.hy.skanova.net ([81.228.8.183]:37490 "EHLO
	av11-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936077Ab0COKIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:08:21 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 06:08:20 EDT
Message-ID: <4B9E0160.5000900@pelagicore.com>
Date: Mon, 15 Mar 2010 10:44:00 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-serial@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
References: <4B532CF5.7080000@gmail.com> <20100117181702.026269e9@lxorguk.ukuu.org.uk> <4B535ED8.2050703@gmail.com>
In-Reply-To: <4B535ED8.2050703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

On 01/17/2010 08:02 PM, Roel Kluin wrote:
> Dear Richard Röjfors,
>
> It is possible that I found a bug in the Timberdale UART driver that was added
> to the linux kernel. The patch below tries to fix this, note the RTS to CTS
> change, could you confirm whether the patch below changes your driver
> correctly?

Thanks for finding this, I have a comment on the patch below.

>
> Thank you,
>
> Roel Kluin
> ----------------->8----------------------------8<-------------------------------
> Regardless of whether the TIOCM_RTS bit was set in mctrl, the same write
> occurred.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
>   drivers/serial/timbuart.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
> index 34b31da..c433d40 100644
> --- a/drivers/serial/timbuart.c
> +++ b/drivers/serial/timbuart.c
> @@ -219,7 +219,7 @@ static void timbuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
>   	if (mctrl&  TIOCM_RTS)
>   		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
>   	else
> -		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
> +		iowrite8(TIMBUART_CTRL_CTS, port->membase + TIMBUART_CTRL);

This is not completely correct. CTS is a read only bit and we are to stop signal RTS.
So the line should look like:
iowrite8(0, port->membase + TIMBUART_CTRL);


>   }
>
>   static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier)

--Richard
