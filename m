Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYFAXcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYFAXcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYFAX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:28:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbYFAX2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=dZ/ofR2+4cNgCjL9HlABHv3KaUn+Ml+VMlGYtVc2rVnJWSruu9UFXHrzgjyf9Tnp/rDLhQJEE82ROGJ6+CgsxDgEThiVTVTf5UMxbQwYdIj2Ja3n1NQ5UIb+z7aiNtzMt6/uR4NinFQoBnJ6/YqaaX+w56mHkc0LleP7Bj1ib9A=
Message-Id: <20080601231610.026536130@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:43 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Subject: [patch -v2 14/23] dcdbas: use memory_read_from_buffer
Content-Disposition: inline; filename=dcdbas-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
---
 drivers/firmware/dcdbas.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/firmware/dcdbas.c
===================================================================
--- 2.6-git.orig/drivers/firmware/dcdbas.c
+++ 2.6-git/drivers/firmware/dcdbas.c
@@ -34,6 +34,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 #include <asm/io.h>
 
 #include "dcdbas.h"
@@ -152,20 +153,11 @@ static ssize_t smi_data_read(struct kobj
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
-	size_t max_read;
 	ssize_t ret;
 
 	mutex_lock(&smi_data_lock);
-
-	if (pos >= smi_data_buf_size) {
-		ret = 0;
-		goto out;
-	}
-
-	max_read = smi_data_buf_size - pos;
-	ret = min(max_read, count);
-	memcpy(buf, smi_data_buf + pos, ret);
-out:
+	ret = memory_read_from_buffer(buf, count, &pos, smi_data_buf,
+					smi_data_buf_size);
 	mutex_unlock(&smi_data_lock);
 	return ret;
 }

-- 
