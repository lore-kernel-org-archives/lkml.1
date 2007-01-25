Return-Path: <linux-kernel-owner+w=401wt.eu-S965731AbXAYJ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbXAYJ30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965732AbXAYJ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:29:26 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:4242 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXAYJ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:29:25 -0500
Date: Thu, 25 Jan 2007 10:29:24 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: au1xmmc: implement proper ro switch detection
Message-ID: <20070125092924.GB8512@roarinelk.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


au1xmmc: implement proper R/O switch detection.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>

--- a/drivers/mmc/au1xmmc.c.orig	2007-01-25 09:56:10.851983000 +0100
+++ b/drivers/mmc/au1xmmc.c	2007-01-25 10:13:12.121983000 +0100
@@ -152,8 +152,9 @@ static inline int au1xmmc_card_inserted(
 		? 1 : 0;
 }
 
-static inline int au1xmmc_card_readonly(struct au1xmmc_host *host)
+static int au1xmmc_card_readonly(struct mmc_host *mmc)
 {
+	struct au1xmmc_host *host = mmc_priv(mmc);
 	return (bcsr->status & au1xmmc_card_table[host->id].wpstatus)
 		? 1 : 0;
 }
@@ -878,6 +885,7 @@ static void au1xmmc_init_dma(struct au1x
 struct mmc_host_ops au1xmmc_ops = {
 	.request	= au1xmmc_request,
 	.set_ios	= au1xmmc_set_ios,
+	.get_ro		= au1xmmc_card_readonly,
 };
 
 static int __devinit au1xmmc_probe(struct platform_device *pdev)
