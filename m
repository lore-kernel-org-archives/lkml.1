Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZFUV5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZFUV5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZFUV5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:57:35 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57939 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZFUV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:57:35 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] base: firmware_class, fix lock imbalance
Date: Sun, 21 Jun 2009 23:57:31 +0200
Message-Id: <1245621451-26814-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted unlock in firmware_data_read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/base/firmware_class.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ddeb819..2da4803 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -217,8 +217,10 @@ firmware_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > fw->size)
-		return 0;
+	if (offset > fw->size) {
+		ret_count = 0;
+		goto out;
+	}
 	if (count > fw->size - offset)
 		count = fw->size - offset;
 
-- 
1.6.3.2

