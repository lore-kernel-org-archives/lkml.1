Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZGaSK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZGaSK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZGaSK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:10:56 -0400
Received: from xenotime.net ([72.52.64.118]:52578 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751819AbZGaSK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:10:56 -0400
Date: Fri, 31 Jul 2009 11:10:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: devel@driverdev.osuosl.org, gregkh@suse.de
Subject: [PATCH] staging/android/lowmemorykiller: fix module param errors
Message-Id: <20090731111045.8dfd1ea5.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move module_params to near the end of the source file so that
their references are already known/defined.  Fixes build errors:

drivers/staging/android/lowmemorykiller.c: In function '__check_cost':
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared (first use in this function)
drivers/staging/android/lowmemorykiller.c: At top level:
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared here (not in a function)
drivers/staging/android/lowmemorykiller.c:60: warning: type defaults to 'int' in declaration of 'type name'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/android/lowmemorykiller.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20090731.orig/drivers/staging/android/lowmemorykiller.c
+++ linux-next-20090731/drivers/staging/android/lowmemorykiller.c
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
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
