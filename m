Return-Path: <linux-kernel-owner+w=401wt.eu-S1761352AbXEYKrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbXEYKrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXEYKrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:47:33 -0400
Received: from [216.16.235.2] ([216.16.235.2]:57630 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXEYKrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:47:33 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 25 May 2007 06:46:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tty_io: Use kzalloc
In-Reply-To: <20070525124258.5b72f077@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0705250645450.11245@localhost.localdomain>
References: <20070525124258.5b72f077@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.541, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Z 0.26)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Jean Delvare wrote:

> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> Andrew, can you please pick this? I couldn't find any maintainer for
> this driver. Thanks.
>
>  drivers/char/tty_io.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> --- linux-2.6.22-rc2.orig/drivers/char/tty_io.c	2007-05-25 08:43:16.000000000 +0200
> +++ linux-2.6.22-rc2/drivers/char/tty_io.c	2007-05-25 08:43:24.000000000 +0200
> @@ -2009,11 +2009,10 @@ static int init_dev(struct tty_driver *d
>  	}
>
>  	if (!*ltp_loc) {
> -		ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
> +		ltp = (struct ktermios *) kzalloc(sizeof(struct ktermios),
>  						 GFP_KERNEL);
>  		if (!ltp)
>  			goto free_mem_out;
> -		memset(ltp, 0, sizeof(struct ktermios));
>  	}
>
>  	if (driver->type == TTY_DRIVER_TYPE_PTY) {
> @@ -2043,10 +2042,9 @@ static int init_dev(struct tty_driver *d
>
>  		if (!*o_ltp_loc) {
>  			o_ltp = (struct ktermios *)
> -				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
> +				kzalloc(sizeof(struct ktermios), GFP_KERNEL);
>  			if (!o_ltp)
>  				goto free_mem_out;
> -			memset(o_ltp, 0, sizeof(struct ktermios));
>  		}
>
>  		/*

i believe you can drop the casts from those calls to kzalloc(), no?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
