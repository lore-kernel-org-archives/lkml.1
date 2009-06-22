Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbZFVVzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbZFVVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFVVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:54:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbZFVVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:54:56 -0400
Date: Mon, 22 Jun 2009 14:53:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] serial: bfin_5xx: add missing spin_lock init
Message-Id: <20090622145331.e6a485df.akpm@linux-foundation.org>
In-Reply-To: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
References: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 20:48:12 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> The Blackfin serial driver never initialized the spin_lock that is part of
> the serial core structure, but we never noticed because spin_lock's are
> rarely enabled on UP systems.  Yeah lockdep and friends.
> 

I'm sitting here wondering if we need this in -stable, but the changlog
failed to provide sufficient information to determine this.

>  drivers/serial/bfin_5xx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index e2f6b1b..d7fcca1 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -1110,6 +1110,7 @@ static void __init bfin_serial_init_ports(void)
>  	bfin_serial_hw_init();
>  
>  	for (i = 0; i < nr_active_ports; i++) {
> +		spin_lock_init(&bfin_serial_ports[i].port.lock);
>  		bfin_serial_ports[i].port.uartclk   = get_sclk();
>  		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
>  		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;

It _should_ be possible to do this initialisation at compile-time.  But
I expect it would be hard and/or ugly.

