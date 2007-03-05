Return-Path: <linux-kernel-owner+w=401wt.eu-S1751196AbXCEBHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbXCEBHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXCEBHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:07:32 -0500
Received: from canuck.infradead.org ([209.217.80.40]:58487 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbXCEBHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:07:31 -0500
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 20:07:31 EST
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: "'Richard Purdie'" <rpurdie@openedhand.com>,
       "'Nick Piggin'" <nickpiggin@yahoo.com.au>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'kernel list'" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>, <dwmw2@infradead.org>
References: <1172850899.11149.128.camel@localhost.localdomain>
Subject: RE: [PATCH 7/9] mtd: Fix number of free oob spaces in onenand driver
Date: Mon, 5 Mar 2007 09:40:01 +0900
Message-ID: <009201c75ebe$d1ce64b0$c7a3580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1172850899.11149.128.camel@localhost.localdomain>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: Acdc5EAJHzMR4Em1TYarfLbUBQY0pgB2Ukqw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard Purdie,

NAK, Even though we can use it. it's out of Spec. It's reason I don't add
it.

In your swap patch, swap device only uses 4 bytes. so it's enough in
current driver. so we don't need to patch it.

+struct swpdev_oobdata {
+	u16 magic;
+	u16 type;
+} __attribute__((packed));
+
+#define SWPDEV_OOBSIZE		sizeof(struct swpdev_oobdata)
+
+	struct mtd_oob_ops ops;
+
+	ops.len = SWPDEV_OOBSIZE;
+	ops.ooblen = SWPDEV_OOBSIZE;
+	ops.oobbuf = buf;
+	ops.ooboffs = swpdev->fsdata_pos;
+	ops.datbuf = NULL;
+	ops.mode = MTD_OOB_PLACE;

I think this patch is only used at YAFFS case. it uses 28 bytes at spare.
But current spare areas are 20 bytes (2KB page).

Thank you,
Kyungmin Park

> 
> ---
>  drivers/mtd/onenand/onenand_base.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/mtd/onenand/onenand_base.c
> ===================================================================
> --- linux.orig/drivers/mtd/onenand/onenand_base.c	
> 2007-03-02 15:02:31.000000000 +0000
> +++ linux/drivers/mtd/onenand/onenand_base.c	2007-03-02 
> 15:37:05.000000000 +0000
> @@ -33,8 +33,8 @@ static struct nand_ecclayout onenand_oob
>  		56, 57, 58, 59, 60,
>  		},
>  	.oobfree	= {
> -		{2, 3}, {14, 2}, {18, 3}, {30, 2},
> -		{34, 3}, {46, 2}, {50, 3}, {62, 2}
> +		{2, 6}, {14, 4}, {18, 6}, {30, 4},
> +		{34, 6}, {46, 4}, {50, 6}, {62, 2}
>  	}
>  };
>  
> @@ -47,7 +47,7 @@ static struct nand_ecclayout onenand_oob
>  		8, 9, 10, 11, 12,
>  		24, 25, 26, 27, 28,
>  		},
> -	.oobfree	= { {2, 3}, {14, 2}, {18, 3}, {30, 2} }
> +	.oobfree	= { {2, 6}, {14, 4}, {18, 6}, {30, 2} }
>  };
>  
>  static const unsigned char ffchars[] = {
> 

