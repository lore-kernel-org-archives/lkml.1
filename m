Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYFDMNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYFDMNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760735AbYFDMKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760695AbYFDMKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=gTvhr3B3PGGTzS8HbuEpaUyF8Xpal3pdZVmddoGO8KLzQU6qdajcX0SJk8wgOvTf3q
         d0IEWfHunWAWs8iLjRSn18mTtsJHXw24TPwBQ9oYVgiRIw4ka4Zrba/wO+QFGJG5500v
         +GbC6yIrMEL9k1BLFCAbGrmx9/SmEPqWZLX4o=
Message-Id: <20080604115746.808522219@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:42 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: v4l-dvb-maintainer@linuxtv.org
Subject: [patch -v3 09/22] ttusb: use simple_read_from_buffer()
Content-Disposition: inline; filename=ttusb-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: v4l-dvb-maintainer@linuxtv.org
---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

Index: 2.6-git/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
===================================================================
--- 2.6-git.orig/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ 2.6-git/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
+#include <linux/fs.h>
 
 #include "dvb_frontend.h"
 #include "dmxdev.h"
@@ -983,22 +984,9 @@ static int stc_open(struct inode *inode,
 }
 
 static ssize_t stc_read(struct file *file, char *buf, size_t count,
-		 loff_t * offset)
+		 loff_t *offset)
 {
-	int tc = count;
-
-	if ((tc + *offset) > 8192)
-		tc = 8192 - *offset;
-
-	if (tc < 0)
-		return 0;
-
-	if (copy_to_user(buf, stc_firmware + *offset, tc))
-		return -EFAULT;
-
-	*offset += tc;
-
-	return tc;
+	return simple_read_from_buffer(buf, count, offset, stc_firmware, 8192);
 }
 
 static int stc_release(struct inode *inode, struct file *file)

-- 
