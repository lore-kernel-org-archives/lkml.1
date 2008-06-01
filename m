Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYFAXbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYFAXbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbYFAX1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbYFAX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=f+r4INTShQbzfyTp6kmm0zLwg69+N6hlno6d2F7SiRB7NCmN85o1wUXt6JyO57pAuAnmoIPAjpp9/8Yqk8bvbN6JBwnzk4O/q8CeI/KlxMXi+jclr8WlzsE8SMxoeAldGgbX79LRWYTXUh3PcX0qgkYrtWjZrPro9xDWkI/Hzow=
Message-Id: <20080601231535.555370461@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:39 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: v4l-dvb-maintainer@linuxtv.org
Subject: [patch -v2 10/23] ttusb: use simple_read_from_buffer()
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
