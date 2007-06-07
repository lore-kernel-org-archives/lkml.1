Return-Path: <linux-kernel-owner+w=401wt.eu-S936490AbXFGBzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936490AbXFGBzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935840AbXFGBzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:55:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935523AbXFGBzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:55:11 -0400
Date: Wed, 6 Jun 2007 18:54:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: bzolnier@gmail.com, wildy@petra.hos.u-szeged.hu, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH pata-2.6 fix] hpt366: disallow Ultra133 for HPT374
Message-Id: <20070606185455.fc264488.akpm@linux-foundation.org>
In-Reply-To: <200706062353.28707.sshtylyov@ru.mvista.com>
References: <200706062353.28707.sshtylyov@ru.mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 23:53:28 +0400 Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Eliminate UltraATA/133 support for HPT374 -- the chip isn't capable of this mode
> according to the manual, and doesn't even seem to tolerate 66 MHz DPLL clock...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
>  drivers/ide/pci/hpt366.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/ide/pci/hpt366.c
> ===================================================================
> --- linux-2.6.orig/drivers/ide/pci/hpt366.c
> +++ linux-2.6/drivers/ide/pci/hpt366.c
> @@ -1,5 +1,5 @@
>  /*
> - * linux/drivers/ide/pci/hpt366.c		Version 1.03	May 4, 2007
> + * linux/drivers/ide/pci/hpt366.c		Version 1.04	Jun 4, 2007

argh.  Please just delete this version numbering.  It's a sure-fire way of
maximising patch conflicts.

It's 1.10 in Bart's tree.

>   * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
>   * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
> @@ -106,7 +106,8 @@
>   *   switch  to calculating  PCI clock frequency based on the chip's base DPLL
>   *   frequency
>   * - switch to using the  DPLL clock and enable UltraATA/133 mode by default on
> - *   anything  newer than HPT370/A
> + *   anything  newer than HPT370/A (except HPT374 that is not capable of this
> + *   mode according to the manual)
>   * - fold PCI clock detection and DPLL setup code into init_chipset_hpt366(),
>   *   also fixing the interchanged 25/40 MHz PCI clock cases for HPT36x chips;
>   *   unify HPT36x/37x timing setup code and the speedproc handlers by joining
> @@ -365,7 +366,6 @@ static u32 sixty_six_base_hpt37x[] = {
>  };
>  
>  #define HPT366_DEBUG_DRIVE_INFO		0
> -#define HPT374_ALLOW_ATA133_6		1
>  #define HPT371_ALLOW_ATA133_6		1
>  #define HPT302_ALLOW_ATA133_6		1
>  #define HPT372_ALLOW_ATA133_6		1
> @@ -450,7 +450,7 @@ static struct hpt_info hpt370a __devinit
>  
>  static struct hpt_info hpt374 __devinitdata = {
>  	.chip_type	= HPT374,
> -	.max_mode	= HPT374_ALLOW_ATA133_6 ? 4 : 3,
> +	.max_mode	= 3,
>  	.dpll_clk	= 48,
>  	.settings	= hpt37x_settings
>  };

The code in Bart's tree has

static struct hpt_info hpt374 __devinitdata = {
	.chip_type	= HPT374,
	.max_ultra	= HPT374_ALLOW_ATA133_6 ? 6 : 5,
	.dpll_clk	= 48,
	.settings	= hpt37x_settings
};

I can handle the renaming, but note that Bart's tree has different values
as well.

