Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZCKUl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZCKUl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbZCKUlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:41:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZCKUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:41:49 -0400
Date: Wed, 11 Mar 2009 13:39:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben@simtec.co.uk>
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Subject: Re: s3cmci: fix s3c2410_dma_config() arguments.
Message-Id: <20090311133946.0fffc898.akpm@linux-foundation.org>
In-Reply-To: <20090310235711.185285440@fluff.org.uk>
References: <20090310235711.185285440@fluff.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 23:57:11 +0000
Ben Dooks <ben@simtec.co.uk> wrote:

> From: Ben Dooks <ben@simtec.co.uk>
> 
> The s3cmci driver is calling s3c2410_dma_config with incorrect data
> for the DCON register. The S3C2410_DCON_HWTRIG is implicit in the
> channel configuration and the device selection of S3C2410_DCON_CH0_SDI
> is incorrect as the DMA system may not select channel 0.
> 
> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> 
> Index: linux.git/drivers/mmc/host/s3cmci.c
> ===================================================================
> --- linux.git.orig/drivers/mmc/host/s3cmci.c	2009-01-20 09:07:50.000000000 +0000
> +++ linux.git/drivers/mmc/host/s3cmci.c	2009-01-20 09:08:11.000000000 +0000
> @@ -793,8 +793,7 @@ static void s3cmci_dma_setup(struct s3cm
>  			      host->mem->start + host->sdidata);
>  
>  	if (!setup_ok) {
> -		s3c2410_dma_config(host->dma, 4,
> -			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
> +		s3c2410_dma_config(host->dma, 4, 0);
>  		s3c2410_dma_set_buffdone_fn(host->dma,
>  					    s3cmci_dma_done_callback);
>  		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);
> 

This looks like 2.6.29 material?

mmc-in-mmc_power_up-use-previously-selected-ocr-if-available.patch also
looks like 2.6.29 material to me, but Pierre isn't answering the phone.

I'll scoot both these into Linus tomorrowish unless told otherwise.
