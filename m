Return-Path: <linux-kernel-owner+w=401wt.eu-S1763814AbYDQOix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763814AbYDQOix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYDQOio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:38:44 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1628 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755945AbYDQOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:38:43 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 10:38:43 EDT
From: thomas@tungstengraphics.com
To: linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Subject: [PATCH] Fix loading of large firmware files.
Reply-To: thomas@tungstengraphics.com
Date: Thu, 17 Apr 2008 16:21:40 +0200
Message-Id: <12084421001860-git-send-email-thomas@tungstengraphics.com>
X-Mailer: git-send-email 1.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thomas@tungstengraphics.com>

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4a1b9bf..4215cbf 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -206,7 +206,9 @@ fw_realloc_buffer(struct firmware_priv *
 	if (min_size <= fw_priv->alloc_size)
 		return 0;
 
-	new_size = ALIGN(min_size, PAGE_SIZE);
+	new_size = 2 * new_size;
+	new_size = (min_size > new_size) ? min_size : new_size;
+	new_size = ALIGN(new_size, PAGE_SIZE);
 	new_data = vmalloc(new_size);
 	if (!new_data) {
 		printk(KERN_ERR "%s: unable to alloc buffer\n", __FUNCTION__);
-- 
1.4.1


