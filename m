Return-Path: <linux-kernel-owner+w=401wt.eu-S972920AbXHMNlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972920AbXHMNlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935775AbXHMJ7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:59:14 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:42830 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbXHMJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:59:10 -0400
Subject: [KJ] replacing kmalloc with kzalloc in drivers/net/sb1250-mac.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: netdev@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 15:28:43 +0530
Message-Id: <1186999123.29518.18.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 09:59:21.0418 (UTC) FILETIME=[9EE4EAA0:01C7DD90]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in 
drivers/net/sb1250-mac.c


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
---

diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index e7fdcf1..2dca5a7 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -760,7 +760,7 @@ static void sbdma_initctx(sbmacdma_t *d,
 
 	d->sbdma_dscrtable_unaligned =
 	d->sbdma_dscrtable = (sbdmadscr_t *)
-		kmalloc((d->sbdma_maxdescr+1)*sizeof(sbdmadscr_t), GFP_KERNEL);
+		kzalloc((d->sbdma_maxdescr+1)*sizeof(sbdmadscr_t), GFP_KERNEL);
 
 	/*
 	 * The descriptor table must be aligned to at least 16 bytes or the
@@ -769,8 +769,6 @@ static void sbdma_initctx(sbmacdma_t *d,
 	d->sbdma_dscrtable = (sbdmadscr_t *)
 		ALIGN((unsigned long)d->sbdma_dscrtable, sizeof(sbdmadscr_t));
 
-	memset(d->sbdma_dscrtable,0,d->sbdma_maxdescr*sizeof(sbdmadscr_t));
-
 	d->sbdma_dscrtable_end = d->sbdma_dscrtable + d->sbdma_maxdescr;
 
 	d->sbdma_dscrtable_phys = virt_to_phys(d->sbdma_dscrtable);
@@ -780,9 +778,7 @@ static void sbdma_initctx(sbmacdma_t *d,
 	 */
 
 	d->sbdma_ctxtable = (struct sk_buff **)
-		kmalloc(d->sbdma_maxdescr*sizeof(struct sk_buff *), GFP_KERNEL);
-
-	memset(d->sbdma_ctxtable,0,d->sbdma_maxdescr*sizeof(struct sk_buff *));
+		kzalloc(d->sbdma_maxdescr*sizeof(struct sk_buff *), GFP_KERNEL);
 
 #ifdef CONFIG_SBMAC_COALESCE
 	/*

--
thanks
surya.
