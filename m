Return-Path: <linux-kernel-owner+w=401wt.eu-S1763662AbXJRHQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763662AbXJRHQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbXJRHQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:16:19 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:41990 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761041AbXJRHQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:16 -0400
Subject: Re: [PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary
	header file
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Karsten Keil <kkeil@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070825193014.GA2370@pingi.kke.suse.de>
References: <20070825193014.GA2370@pingi.kke.suse.de>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 18 Oct 2007 16:16:03 +0900
Message-Id: <1192691763.20694.5.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

What happened to this patch? Should I send it to Andrew or will you take
it in your tree before pushing it upstream?

Thank you in advance.

 - Fernando

On Sat, 2007-08-25 at 21:30 +0200, Karsten Keil wrote:
> [PATCH] isdn/sc: remove unused REQUEST_IRQ and unnecessary
> 
> REQUEST_IRQ is never used, so delete it. In the process get rid of the
> macro FREE_IRQ which makes the code unnecessarily difficult to read.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> Acked-by: Karsten Keil <kkeil@suse.de>
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
> diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/includes.h linux-2.6.23-rc3/drivers/isdn/sc/includes.h
> --- linux-2.6.23-rc3-orig/drivers/isdn/sc/includes.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.23-rc3/drivers/isdn/sc/includes.h	2007-08-24 20:55:45.000000000 +0900
> @@ -14,4 +14,3 @@
>  #include <linux/timer.h>
>  #include <linux/wait.h>
>  #include <linux/isdnif.h>
> -#include "debug.h"
> diff -urNp linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c linux-2.6.23-rc3/drivers/isdn/sc/init.c
> --- linux-2.6.23-rc3-orig/drivers/isdn/sc/init.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.23-rc3/drivers/isdn/sc/init.c	2007-08-24 20:31:58.000000000 +0900
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

