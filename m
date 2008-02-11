Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYBKVKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYBKVKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYBKVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:10:16 -0500
Received: from vsmtp4.tin.it ([212.216.176.224]:51894 "EHLO vsmtp4.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYBKVKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:10:15 -0500
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] block/genhd.c: compilation warning fix
Date: Mon, 11 Feb 2008 22:10:17 +0100
User-Agent: KMail/1.9.7
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112210.17467.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Added a check for the class_register() return value.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

The aim of this patch is to remove the following warning message:
block/genhd.c: In function 'genhd_device_init':
block/genhd.c:361: warning: ignoring return value of 'class_register', declared with attribute warn_unused_result

--- linux-2.6.orig/block/genhd.c
+++ linux-2.6/block/genhd.c
@@ -358,7 +358,12 @@ static struct kobject *base_probe(dev_t 
 
 static int __init genhd_device_init(void)
 {
-	class_register(&block_class);
+	int ret;
+
+	ret = class_register(&block_class);
+	if (ret != 0)
+		return ret;
+
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
 	blk_dev_init();
 
