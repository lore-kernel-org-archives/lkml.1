Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0CKEBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:01:10 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:34169 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab0CKEBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OninM1Sp0XLu2ETdGDqncrhn0OA5kF75xWJmHPHu2sdK5wwsbwuSk6D7R7LUaTsEO4
         ymEA32Ettu6y2Rj5TsRAZ3Rxl6pXSadm2aSDgBo0INR+8lP0HRf0KCywEcdfav2Nfvkj
         E4Y3qSdhcNwAKty0d92hqalz6y8fIwsTzJxRo=
From: Bruno Bigras <bigras.bruno@gmail.com>
To: jeremy@xensource.com
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Bruno Bigras <bigras.bruno@gmail.com>
Subject: [PATCH 1/2] xen: balloon: Fix checkpatch issues
Date: Wed, 10 Mar 2010 23:00:53 -0500
Message-Id: <1268280054-16170-1-git-send-email-bigras.bruno@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/xen/balloon.c:50: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
drivers/xen/balloon.c:158: ERROR: else should follow close brace '}'
drivers/xen/balloon.c:277: ERROR: do not use assignment in if condition
drivers/xen/balloon.c:293: ERROR: code indent should use tabs where possible
drivers/xen/balloon.c:364: ERROR: that open brace { should be on the previous line
drivers/xen/balloon.c:463: WARNING: line over 80 characters
drivers/xen/balloon.c:491: WARNING: line over 80 characters

Signed-off-by: Bruno Bigras <bigras.bruno@gmail.com>
---
 drivers/xen/balloon.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index f6738d8..93538a8 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -43,11 +43,11 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
+#include <linux/uaccess.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
-#include <asm/uaccess.h>
 #include <asm/tlb.h>
 
 #include <asm/xen/hypervisor.h>
@@ -154,8 +154,7 @@ static struct page *balloon_retrieve(void)
 	if (PageHighMem(page)) {
 		balloon_stats.balloon_high--;
 		inc_totalhigh_pages();
-	}
-	else
+	} else
 		balloon_stats.balloon_low--;
 
 	totalram_pages++;
@@ -274,7 +273,8 @@ static int decrease_reservation(unsigned long nr_pages)
 		nr_pages = ARRAY_SIZE(frame_list);
 
 	for (i = 0; i < nr_pages; i++) {
-		if ((page = alloc_page(GFP_BALLOON)) == NULL) {
+		page = alloc_page(GFP_BALLOON);
+		if (!page) {
 			nr_pages = i;
 			need_sleep = 1;
 			break;
@@ -290,7 +290,7 @@ static int decrease_reservation(unsigned long nr_pages)
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				__pte_ma(0), 0);
 			BUG_ON(ret);
-                }
+		}
 
 	}
 
@@ -360,8 +360,7 @@ static void balloon_set_new_target(unsigned long target)
 	schedule_work(&balloon_worker);
 }
 
-static struct xenbus_watch target_watch =
-{
+static struct xenbus_watch target_watch = {
 	.node = "memory/target"
 };
 
@@ -460,8 +459,8 @@ BALLOON_SHOW(low_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_low));
 BALLOON_SHOW(high_kb, "%lu\n", PAGES2KB(balloon_stats.balloon_high));
 BALLOON_SHOW(driver_kb, "%lu\n", PAGES2KB(balloon_stats.driver_pages));
 
-static ssize_t show_target_kb(struct sys_device *dev, struct sysdev_attribute *attr,
-			      char *buf)
+static ssize_t show_target_kb(struct sys_device *dev,
+			      struct sysdev_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%lu\n", PAGES2KB(balloon_stats.target_pages));
 }
@@ -488,8 +487,8 @@ static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
 		   show_target_kb, store_target_kb);
 
 
-static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr,
-			      char *buf)
+static ssize_t show_target(struct sys_device *dev,
+			   struct sysdev_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%llu\n",
 		       (unsigned long long)balloon_stats.target_pages
-- 
1.7.0.2

