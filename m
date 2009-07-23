Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZGWQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZGWQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZGWQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:25:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52652 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZGWQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:25:24 -0400
Date: Thu, 23 Jul 2009 21:55:01 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 23
Message-ID: <20090723162501.GA9203@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090723163201.6951a44b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090723163201.6951a44b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

	next-20090723 randconfig build breaks at

drivers/staging/android/lowmemorykiller.c: In function '__check_cost':
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared (first use in this function)
drivers/staging/android/lowmemorykiller.c:60: error: (Each undeclared identifier is reported only once
drivers/staging/android/lowmemorykiller.c:60: error: for each function it appears in.)
drivers/staging/android/lowmemorykiller.c: At top level:
drivers/staging/android/lowmemorykiller.c:60: error: 'lowmem_shrinker' undeclared here (not in a function)
drivers/staging/android/lowmemorykiller.c:60: warning: type defaults to 'int' in declaration of 'type name'
make[3]: *** [drivers/staging/android/lowmemorykiller.o] Error 1
make[2]: *** [drivers/staging/android] Error 2
make[1]: *** [drivers/staging] Error 2

I have tested the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux/drivers/staging/android/lowmemorykiller.c	2009-07-23 12:15:59.000000000 -0400
+++ linux/drivers/staging/android/~lowmemorykiller.c	2009-07-23 12:17:46.000000000 -0400
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
@@ -155,6 +148,13 @@ static struct shrinker lowmem_shrinker =
 	.seeks = DEFAULT_SEEKS * 16
 };
 
+module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
+module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
+			 S_IRUGO | S_IWUSR);
+module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
+			 S_IRUGO | S_IWUSR);
+module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
+
 static int __init lowmem_init(void)
 {
 	register_shrinker(&lowmem_shrinker);

			
					Kamalesh
