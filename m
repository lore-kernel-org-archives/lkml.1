Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZAHMhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZAHMhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZAHMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:37:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48775 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbZAHMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:37:27 -0500
Date: Thu, 8 Jan 2009 12:36:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Milton Miller <miltonm@bga.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>
Subject: Re: [PATCH 1/4] hvc_console: do not set low_latency
Message-ID: <20090108123619.3543719f@lxorguk.ukuu.org.uk>
In-Reply-To: <hvc-console-29-3-1@bga.com>
References: <hvc-console-29-3@bga.com>
	<hvc-console-29-3-1@bga.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> v2.6.16-rc1 via 33f0f88f1c51ae5c2d593d26960c760ea154c2e2
>     [PATCH] TTY layer buffering revamp
> 
> added this new api.

No - tty_flip_buffer_push is from 2.1.66 and with the same constraints
from the day it was added.


> Having the flag set for purely polled drivers will save delaying
> the work when receiving input for 1 jiffie.
> 
> 
> Index: work.git/drivers/char/hvc_console.c
> ===================================================================
> --- work.git.orig/drivers/char/hvc_console.c	2009-01-08 03:01:24.000000000 -0600
> +++ work.git/drivers/char/hvc_console.c	2009-01-08 03:01:51.000000000 -0600
> @@ -318,7 +318,8 @@ static int hvc_open(struct tty_struct *t
>  	} /* else count == 0 */
>  
>  	tty->driver_data = hp;
> -	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> +	if (!hp->irq_requested)
> +		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
>  
>  	hp->tty = tty;

Looks good to me
