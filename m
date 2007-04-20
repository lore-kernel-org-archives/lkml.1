Return-Path: <linux-kernel-owner+w=401wt.eu-S2993266AbXDTP0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993266AbXDTP0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993268AbXDTP0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:26:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45519 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993266AbXDTP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:26:14 -0400
Date: Fri, 20 Apr 2007 16:29:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Yenya Kasprzak <kas@fi.muni.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Char: mxser_new, fix recursive locking
Message-ID: <20070420162931.44f426e9@the-village.bc.nu>
In-Reply-To: <20070420141551.GQ22955@fi.muni.cz>
References: <20225157853131727049@wsc.cz>
	<20070420131210.166fcd40@the-village.bc.nu>
	<20070420141551.GQ22955@fi.muni.cz>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Acked-by: Alan Cox <alan@redhat.com>
> 
> --- linux-2.6.21-rc2/drivers/char/mxser_new.c.orig	2007-04-20 15:41:46.000000000 +0200
> +++ linux-2.6.21-rc2/drivers/char/mxser_new.c	2007-04-20 15:46:46.000000000 +0200
> @@ -2230,7 +2230,14 @@
>  	port->mon_data.rxcnt += cnt;
>  	port->mon_data.up_rxcnt += cnt;
>  
> +	/*
> +	 * We are called from an interrupt context with &port->slock
> +	 * being held. Drop it temporarily in order to prevent
> +	 * recursive locking.
> +	 */
> +	spin_unlock(&port->slock);
>  	tty_flip_buffer_push(tty);
> +	spin_lock(&port->slock);
>  }
>  
