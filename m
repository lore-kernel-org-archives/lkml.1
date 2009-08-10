Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZHJTfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZHJTfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZHJTfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:35:31 -0400
Received: from kroah.org ([198.145.64.141]:51383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZHJTfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:35:31 -0400
Subject: patch staging-android-lowmemorykiller-fix-module-param-errors.patch added to gregkh-2.6 tree
To: rdunlap@xenotime.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
From: <gregkh@suse.de>
Date: Mon, 10 Aug 2009 12:34:13 -0700
In-Reply-To: <20090731111045.8dfd1ea5.rdunlap@xenotime.net>
Message-ID: <12499328531180@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: android: lowmemorykiller: fix module param errors

to my gregkh-2.6 tree.  Its filename is

    staging-android-lowmemorykiller-fix-module-param-errors.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rdunlap@xenotime.net  Mon Aug 10 11:43:15 2009
From: Randy Dunlap <rdunlap@xenotime.net>
Date: Fri, 31 Jul 2009 11:10:45 -0700
Subject: Staging: android: lowmemorykiller: fix module param errors
To: lkml <linux-kernel@vger.kernel.org>
Cc: devel@driverdev.osuosl.org, gregkh@suse.de
Message-ID: <20090731111045.8dfd1ea5.rdunlap@xenotime.net>


From: Randy Dunlap <randy.dunlap@oracle.com>

Move module_params to near the end of the source file so that
their references are already known/defined.  Fixes build errors:

drivers/staging/android/lowmemorykiller.c: In function '__check_cost':
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared (first use in this function)
drivers/staging/android/lowmemorykiller.c: At top level:
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared here (not in a function)
drivers/staging/android/lowmemorykiller.c:60: warning: type defaults to 'int' in declaration of 'type name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/android/lowmemorykiller.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -57,13 +57,6 @@ static int lowmem_minfree_size = 4;
 			printk(x);			\
 	} while (0)
 
-module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
-module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
-			 S_IRUGO | S_IWUSR);
-module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
-			 S_IRUGO | S_IWUSR);
-module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
-
 static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 {
 	struct task_struct *p;
@@ -166,6 +159,13 @@ static void __exit lowmem_exit(void)
 	unregister_shrinker(&lowmem_shrinker);
 }
 
+module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
+module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
+			 S_IRUGO | S_IWUSR);
+module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
+			 S_IRUGO | S_IWUSR);
+module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
+
 module_init(lowmem_init);
 module_exit(lowmem_exit);
 

