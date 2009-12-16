Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZLPBUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZLPBUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZLPBUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:20:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64404 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZLPBUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:20:32 -0500
Date: Wed, 16 Dec 2009 10:20:30 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: RE: [PATCH] OneNAND: Fix test of unsigned in onenand_otp_walk()
In-reply-to: <4B282BBD.4050106@gmail.com>
To: "'Roel Kluin'" <roel.kluin@gmail.com>, linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Reply-to: kyungmin.park@samsung.com
Message-id: <003301ca7ded$f50a8930$df1f9b90$%park@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acp956rNhxFvjG+zRT2Uz18h1rCaGQABkE0Q
References: <4B282BBD.4050106@gmail.com>
X-OriginalArrivalTime: 16 Dec 2009 01:20:30.0559 (UTC)
 FILETIME=[F50ECEF0:01CA7DED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

> -----Original Message-----
> From: Roel Kluin [mailto:roel.kluin@gmail.com]
> Sent: Wednesday, December 16, 2009 9:37 AM
> To: Kyungmin Park; linux-mtd@lists.infradead.org; Andrew Morton; LKML
> Subject: [PATCH] OneNAND: Fix test of unsigned in onenand_otp_walk()
> 
> mtd->writesize and len are unsigned so the test does not work.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> you can test this with:
> 
> #include <stdio.h>
> 
> int main()
> {
>         int c = 1, d = 1;
>         unsigned a = 30;
>         unsigned b = 10;
> 
>         if ((b * c) - (d + a) < 0)
>                 printf("good\n");
>         else
>                 printf("bad\n");
>         return 0;
> }
> 
> 
> diff --git a/drivers/mtd/onenand/onenand_base.c
> b/drivers/mtd/onenand/onenand_base.c
> index ff66e43..cbe2711 100644
> --- a/drivers/mtd/onenand/onenand_base.c
> +++ b/drivers/mtd/onenand/onenand_base.c
> @@ -2725,7 +2725,7 @@ static int onenand_otp_walk(struct mtd_info *mtd,
> loff_t from, size_t len,
>  	}
> 
>  	/* Check User/Factory boundary */
> -	if (((mtd->writesize * otp_pages) - (from + len)) < 0)
> +	if (mtd->writesize * otp_pages < from + len)
>  		return 0;
> 
>  	onenand_get_device(mtd, FL_OTPING);

