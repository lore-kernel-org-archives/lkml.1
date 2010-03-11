Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab0CKQQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:16:18 -0500
Received: from smtp.nokia.com ([192.100.105.134]:24481 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190Ab0CKQQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:16:16 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: sonnyrao@us.ibm.com, benh@kernel.crashing.org, tklauser@distanz.ch,
       jkosina@suse.cz, ext-jani.1.nikula@nokia.com
Subject: [PATCH] powerpc/BSR: fix device_create() return value check
Date: Thu, 11 Mar 2010 18:15:53 +0200
Message-Id: <1268324153-30345-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 11 Mar 2010 16:16:01.0127 (UTC) FILETIME=[24159770:01CAC136]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Use IS_ERR() instead of comparing to NULL.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>

---

NOTE: I'm afraid I'm unable to test this; please consider this more a
bug report than a complete patch.
---
 drivers/char/bsr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index c02db01..3b31f74 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -252,7 +252,7 @@ static int bsr_add_node(struct device_node *bn)
 
 		cur->bsr_device = device_create(bsr_class, NULL, cur->bsr_dev,
 						cur, cur->bsr_name);
-		if (!cur->bsr_device) {
+		if (IS_ERR(cur->bsr_device)) {
 			printk(KERN_ERR "device_create failed for %s\n",
 			       cur->bsr_name);
 			cdev_del(&cur->bsr_cdev);
-- 
1.6.5.2

