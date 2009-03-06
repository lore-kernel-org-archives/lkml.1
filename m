Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZCFWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZCFWj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZCFWjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941AbZCFWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:06 -0500
Date: Fri, 6 Mar 2009 14:38:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 14/18] Blackfin Serial Driver: use the DLAB macro to
 hide variant differences
Message-Id: <20090306143821.268b7f00.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-15-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-15-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:56 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/serial/bfin_5xx.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index b89861d..71a9e6b 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -1250,7 +1250,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
>  void bfin_serial_debug(const char *fmt, ...)
>  {
>  	struct bfin_serial_port *uart = &bfin_serial_ports[0];
> -	unsigned short status, tmp;
> +	unsigned short status;
>  	unsigned long flags;
>  	int i, count;
>  	char buf[128];
> @@ -1273,11 +1273,7 @@ void bfin_serial_debug(const char *fmt, ...)
>  			status = UART_GET_LSR(uart);
>  		} while (!(status & THRE));
>  
> -#ifndef CONFIG_BF54x
> -		tmp = UART_GET_LCR(uart);
> -		tmp &= ~DLAB;
> -		UART_PUT_LCR(uart, tmp);
> -#endif
> +		UART_CLEAR_DLAB(uart);
>  		UART_PUT_CHAR(uart, buf[i]);
>  		if (buf[i] == '\n') {
>  			do {

This appears to be a small cleanup, not a bugfix.

I'm OK with sneaking the odd non-bugfix into late -rc by accident -
it's not teribly important, and getting the main bugs fixed overwhelms
such considerations.

However I have a sneaky suspicion that this patch might actually fix a
bug, only we weren't told about it?

