Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbXGPNdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbXGPNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXGPNde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:33:34 -0400
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:47429 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbXGPNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:33:32 -0400
Message-Id: <200707161320.l6GDKDRP006750@mbox.iij4u.or.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH 31/33] Fusion: sg chaining support
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <11845792691073-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<11845792691073-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jul 2007 22:20:13 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 31/33] Fusion: sg chaining support
Date: Mon, 16 Jul 2007 11:47:45 +0200

> Cc: Eric.Moore@lsi.com
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/message/fusion/mptscsih.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index d356173..f087249 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -297,7 +297,7 @@ nextSGEset:
>  		v2 = sg_dma_address(sg);
>  		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
>  
> -		sg++;		/* Get next SG element from the OS */
> +		sg = sg_next(sg);	/* Get next SG element from the OS */
>  		psge += (sizeof(u32) + sizeof(dma_addr_t));
>  		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
>  		sg_done++;
> @@ -318,7 +318,7 @@ nextSGEset:
>  		v2 = sg_dma_address(sg);
>  		mptscsih_add_sge(psge, sgflags | thisxfer, v2);
>  		/*
> -		sg++;
> +		sg = sg_next(sg);
>  		psge += (sizeof(u32) + sizeof(dma_addr_t));
>  		*/
>  		sgeOffset += (sizeof(u32) + sizeof(dma_addr_t));
> -- 

We also need this change?

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f087249..a3e6170 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -289,7 +289,7 @@ nextSGEset:
 	for (ii=0; ii < (numSgeThisFrame-1); ii++) {
 		thisxfer = sg_dma_len(sg);
 		if (thisxfer == 0) {
-			sg ++; /* Get next SG element from the OS */
+			sg = sg_next(sg); /* Get next SG element from the OS */
 			sg_done++;
 			continue;
 		}
-- 
1.4.3.2

