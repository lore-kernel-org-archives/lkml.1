Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZGLWre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZGLWre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZGLWqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:34 -0400
Received: from kroah.org ([198.145.64.141]:33503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbZGLWqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/9] Firmware: firmware_class, fix lock imbalance
Date: Sun, 12 Jul 2009 15:46:02 -0700
Message-Id: <1247438766-17266-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Add omitted unlock in firmware_data_read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index fc46653..f285f44 100644
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

