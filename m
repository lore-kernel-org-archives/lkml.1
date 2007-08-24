Return-Path: <linux-kernel-owner+w=401wt.eu-S1765116AbXHXJfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765116AbXHXJfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 05:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbXHXJfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 05:35:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54268 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761031AbXHXJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 05:35:09 -0400
Date: Fri, 24 Aug 2007 11:33:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de
Subject: Re: [PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary
	header file
Message-ID: <20070824093355.GZ30705@stusta.de>
References: <1187947647.2570.11.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1187947647.2570.11.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 06:27:27PM +0900, Fernando Luis Vázquez Cao wrote:

> REQUEST_IRQ is never used, so delete it. In the process get rid of the
> macro FREE_IRQ which makes the code unnecessarily difficult to read.

The header you remove get's #include'd somewhere - and this #include 
must be removed or your patch creates a compile error.

> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/debug.h linux-2.6.23-rc3/drivers/isdn/sc/debug.h
> --- linux-2.6.23-rc3-orig/drivers/isdn/sc/debug.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.23-rc3/drivers/isdn/sc/debug.h	1970-01-01 09:00:00.000000000 +0900
> @@ -1,19 +0,0 @@
> -/* $Id: debug.h,v 1.2.8.1 2001/09/23 22:24:59 kai Exp $
> - *
> - * Copyright (C) 1996  SpellCaster Telecommunications Inc.
> - *
> - * This software may be used and distributed according to the terms
> - * of the GNU General Public License, incorporated herein by reference.
> - *
> - * For more information, please contact gpl-info@spellcast.com or write:
> - *
> - *     SpellCaster Telecommunications Inc.
> - *     5621 Finch Avenue East, Unit #3
> - *     Scarborough, Ontario  Canada
> - *     M1B 2T9
> - *     +1 (416) 297-8565
> - *     +1 (416) 297-6433 Facsimile
> - */
> -
> -#define REQUEST_IRQ(a,b,c,d,e) request_irq(a,b,c,d,e)
> -#define FREE_IRQ(a,b) free_irq(a,b)
> diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c linux-2.6.23-rc3/drivers/isdn/sc/init.c
> --- linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.23-rc3/drivers/isdn/sc/init.c	2007-08-24 18:12:27.000000000 +0900
> @@ -404,7 +404,7 @@ static void __exit sc_exit(void)
>  		/*
>  		 * Release the IRQ
>  		 */
> -		FREE_IRQ(sc_adapter[i]->interrupt, NULL);
> +		free_irq(sc_adapter[i]->interrupt, NULL);
>  
>  		/*
>  		 * Reset for a clean start
> 
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

