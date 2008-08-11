Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYHKIXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYHKIXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 04:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYHKIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 04:23:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbYHKIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 04:23:12 -0400
Date: Mon, 11 Aug 2008 08:59:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Olaf Schnapper <os@de.ibm.com>
Subject: Re: [PATCH] Fix race/oops in tty layer after BKL pushdown
Message-ID: <20080811085920.59b278b9@lxorguk.ukuu.org.uk>
In-Reply-To: <200808071433.06885.borntraeger@de.ibm.com>
References: <200808071433.06885.borntraeger@de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please review and consider to apply:
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/char/tty_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: kvm/drivers/char/tty_io.c
> ===================================================================
> --- kvm.orig/drivers/char/tty_io.c
> +++ kvm/drivers/char/tty_io.c
> @@ -1161,8 +1161,8 @@ void disassociate_ctty(int on_exit)
>  	tty = get_current_tty();
>  	if (tty) {
>  		tty_pgrp = get_pid(tty->pgrp);
> -		mutex_unlock(&tty_mutex);
>  		lock_kernel();
> +		mutex_unlock(&tty_mutex);
>  		/* XXX: here we race, there is nothing protecting tty */
>  		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
>  			tty_vhangup(tty);

For upstream (see -next tree) I have pushed a refcounting solution (or at
least I hope its a solution) to the ttydev tree. For 2.6.26 your approach
partially fixes this and certainly doesn't make it worse so I'll now push
it onwards.

Alan
