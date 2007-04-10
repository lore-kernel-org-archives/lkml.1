Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXDJWIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXDJWIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXDJWIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:08:15 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:33350
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753962AbXDJWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:08:14 -0400
Date: Wed, 11 Apr 2007 00:05:16 +0200
From: matze <matze@riseup.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] include KERN_* constant in printk() calls in mm/slab.c
Message-ID: <20070410220516.GH24898@traven>
Mail-Followup-To: matze <matze@riseup.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

include KERN_* constant in printk() calls in mm/slab.c

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

---
diff --git a/mm/slab.c b/mm/slab.c
index 4cbac24..5a6e8c8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2151,13 +2151,15 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		 */
 		res = probe_kernel_address(pc->name, tmp);
 		if (res) {
-			printk("SLAB: cache with size %d has lost its name\n",
+			printk(KERN_ERR
+			       "SLAB: cache with size %d has lost its name\n",
 			       pc->buffer_size);
 			continue;
 		}
 
 		if (!strcmp(pc->name, name)) {
-			printk("kmem_cache_create: duplicate cache %s\n", name);
+			printk(KERN_ERR
+			       "kmem_cache_create: duplicate cache %s\n", name);
 			dump_stack();
 			goto oops;
 		}
@@ -2294,7 +2296,8 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	left_over = calculate_slab_order(cachep, size, align, flags);
 
 	if (!cachep->num) {
-		printk("kmem_cache_create: couldn't create cache %s.\n", name);
+		printk(KERN_ERR
+		       "kmem_cache_create: couldn't create cache %s.\n", name);
 		kmem_cache_free(&cache_cache, cachep);
 		cachep = NULL;
 		goto oops;

-- 
      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver keys.indymedia.org --recv-keys B9A88F6F           `-
