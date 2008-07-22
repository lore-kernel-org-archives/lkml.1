Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYGVLLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYGVLLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGVLLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:11:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50767 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379AbYGVLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:11:32 -0400
Date: Tue, 22 Jul 2008 11:53:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [Patch] um: fix a build error
Message-ID: <20080722115354.79ba2314@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722105812.GB5283@alice>
References: <20080722105812.GB5283@alice>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> 
> --- linux-2.6/arch/um/drivers/line.c.orig	2008-07-22 12:06:17.000000000 +0200
> +++ linux-2.6/arch/um/drivers/line.c	2008-07-22 12:06:49.000000000 +0200
> @@ -362,10 +362,8 @@ static irqreturn_t line_write_interrupt(
>  	if (tty == NULL)
>  		return IRQ_NONE;
>  
> -	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
> -	   (tty->ldisc.write_wakeup != NULL))
> -		(tty->ldisc.write_wakeup)(tty);
> -
> +	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
> +		tty_wakeup(tty);

Sorry I should have been clearer - you don't want the test_bit either.

Acked-by: Alan Cox <alan@redhat.com>

however as it is still right but you can stick my Ack on a version
without the if too.
