Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYKYA4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYKYA4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYKYAzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:55:19 -0500
Received: from smtp.movial.fi ([62.236.91.34]:57332 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbYKYAzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:55:14 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Subject: [PATCH 01/20] [MTD] Make lart_flash_init, lart_flash_exit static
Date: Tue, 25 Nov 2008 02:54:52 +0200
Message-Id: <1227574511-23879-2-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1227574511-23879-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols lart_flash_init, lart_flash_exit are needlessly
defined global in drivers/mtd/devices/lart.c, so make them
static.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/mtd/devices/lart.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/devices/lart.c b/drivers/mtd/devices/lart.c
index f4bda4c..578de1c 100644
--- a/drivers/mtd/devices/lart.c
+++ b/drivers/mtd/devices/lart.c
@@ -619,7 +619,7 @@ static struct mtd_partition lart_partitions[] = {
 };
 #endif
 
-int __init lart_flash_init (void)
+static int __init lart_flash_init (void)
 {
    int result;
    memset (&mtd,0,sizeof (mtd));
@@ -690,7 +690,7 @@ int __init lart_flash_init (void)
    return (result);
 }
 
-void __exit lart_flash_exit (void)
+static void __exit lart_flash_exit (void)
 {
 #ifndef HAVE_PARTITIONS
    del_mtd_device (&mtd);
@@ -705,5 +705,3 @@ module_exit (lart_flash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Abraham vd Merwe <abraham@2d3d.co.za>");
 MODULE_DESCRIPTION("MTD driver for Intel 28F160F3 on LART board");
-
-
-- 
1.5.3

