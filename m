Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZHGQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZHGQrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZHGQrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:47:18 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:41657 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZHGQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:47:18 -0400
Message-ID: <4A7C5A3D.4090309@csr.com>
Date: Fri, 07 Aug 2009 17:45:49 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: drzeus@drzeus.cx, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sdio: Read buffer overflow
References: <4A7C4501.7070700@gmail.com>
In-Reply-To: <4A7C4501.7070700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2009 16:45:49.0887 (UTC) FILETIME=[850AB4F0:01CA177E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> If the loop breaks with an index of 0, then we read before the array.

This isn't a helpful subject or changelog comment really.  Suggest

sdio: avoid buffer underrun when parsing an invalid CISTPL_VERS_1

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index 963f293..0f8853c 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -40,7 +40,7 @@ static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
>  			nr_strings++;
>  	}
>  
> -	if (buf[i-1] != '\0') {
> +	if (i != 0 && buf[i-1] != '\0') {

Looking at the PC Card 8.0 spec (vol 4, section 3.2.10) this test could
simply be:

if (nr_strings < 4) {

>  		printk(KERN_WARNING "SDIO: ignoring broken CISTPL_VERS_1\n");
>  		return 0;
>  	}
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
