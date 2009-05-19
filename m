Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZESSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZESSDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZESSDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 14:03:04 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:15212 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751633AbZESSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 14:03:03 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/slub.c: change printk()s to pr_*() notation
Date: Tue, 19 May 2009 11:03:03 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191103.03749.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all the printk()s in mm/slub.c to the pr_*() notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..2805b7f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -338,25 +338,25 @@ static void print_section(char *text, u8 *addr, unsigned int length)
 
 	for (i = 0; i < length; i++) {
 		if (newline) {
-			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
+			pr_err("%8s 0x%p: ", text, addr + i);
 			newline = 0;
 		}
-		printk(KERN_CONT " %02x", addr[i]);
+		pr_cont(" %02x", addr[i]);
 		offset = i % 16;
 		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
 		if (offset == 15) {
-			printk(KERN_CONT " %s\n", ascii);
+			pr_cont(" %s\n", ascii);
 			newline = 1;
 		}
 	}
 	if (!newline) {
 		i %= 16;
 		while (i < 16) {
-			printk(KERN_CONT "   ");
+			pr_cont("   ");
 			ascii[i] = ' ';
 			i++;
 		}
-		printk(KERN_CONT " %s\n", ascii);
+		pr_cont(" %s\n", ascii);
 	}
 }
 
@@ -401,7 +401,7 @@ static void print_track(const char *s, struct track *t)
 	if (!t->addr)
 		return;
 
-	printk(KERN_ERR "INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
+	pr_err("INFO: %s in %pS age=%lu cpu=%u pid=%d\n",
 		s, (void *)t->addr, jiffies - t->when, t->cpu, t->pid);
 }
 
@@ -416,7 +416,7 @@ static void print_tracking(struct kmem_cache *s, void *object)
 
 static void print_page_info(struct page *page)
 {
-	printk(KERN_ERR "INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
+	pr_err("INFO: Slab 0x%p objects=%u used=%u fp=0x%p flags=0x%04lx\n",
 		page, page->objects, page->inuse, page->freelist, page->flags);
 
 }
@@ -429,11 +429,11 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_ERR "========================================"
-			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
-	printk(KERN_ERR "----------------------------------------"
-			"-------------------------------------\n\n");
+	pr_err("========================================"
+		"=====================================\n");
+	pr_err("BUG %s: %s\n", s->name, buf);
+	pr_err("----------------------------------------"
+		"-------------------------------------\n\n");
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
@@ -444,7 +444,7 @@ static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_ERR "FIX %s: %s\n", s->name, buf);
+	pr_err("FIX %s: %s\n", s->name, buf);
 }
 
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
@@ -456,8 +456,8 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 
 	print_page_info(page);
 
-	printk(KERN_ERR "INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
-			p, p - addr, get_freepointer(s, p));
+	pr_err("INFO: Object 0x%p @offset=%tu fp=0x%p\n\n",
+		p, p - addr, get_freepointer(s, p));
 
 	if (p > addr + 16)
 		print_section("Bytes b4", p - 16, 16);
@@ -552,8 +552,8 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 		end--;
 
 	slab_bug(s, "%s overwritten", what);
-	printk(KERN_ERR "INFO: 0x%p-0x%p. First byte 0x%x instead of 0x%x\n",
-					fault, end - 1, fault[0], value);
+	pr_err("INFO: 0x%p-0x%p. First byte 0x%x instead of 0x%x\n",
+		fault, end - 1, fault[0], value);
 	print_trailer(s, page, object);
 
 	restore_bytes(s, what, value, fault, end);
@@ -787,7 +787,7 @@ static void trace(struct kmem_cache *s, struct page *page, void *object,
 								int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
+		pr_info("TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
 			s->name,
 			alloc ? "alloc" : "free",
 			object, page->inuse,
@@ -930,9 +930,8 @@ static int free_debug_processing(struct kmem_cache *s, struct page *page,
 			slab_err(s, page, "Attempt to free object(0x%p) "
 				"outside of slab", object);
 		} else if (!page->slab) {
-			printk(KERN_ERR
-				"SLUB <none>: no slab for object 0x%p.\n",
-						object);
+			pr_err("SLUB <none>: no slab for object 0x%p.\n",
+				object);
 			dump_stack();
 		} else
 			object_err(s, page, object,
@@ -998,7 +997,7 @@ static int __init setup_slub_debug(char *str)
 			slub_debug |= SLAB_TRACE;
 			break;
 		default:
-			printk(KERN_ERR "slub_debug option '%c' "
+			pr_err("slub_debug option '%c' "
 				"unknown. skipped\n", *str);
 		}
 	}
@@ -2116,10 +2115,10 @@ static void early_kmem_cache_node_alloc(gfp_t gfpflags, int node)
 
 	BUG_ON(!page);
 	if (page_to_nid(page) != node) {
-		printk(KERN_ERR "SLUB: Unable to allocate memory from "
-				"node %d\n", node);
-		printk(KERN_ERR "SLUB: Allocating a useless per node structure "
-				"in order to be able to continue\n");
+		pr_err("SLUB: Unable to allocate memory from node %d\n",
+			node);
+		pr_err("SLUB: Allocating a useless per node structure "
+			"in order to be able to continue\n");
 	}
 
 	n = page->freelist;
@@ -2431,8 +2430,8 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 	for_each_object(p, s, addr, page->objects) {
 
 		if (!test_bit(slab_index(p, s, addr), map)) {
-			printk(KERN_ERR "INFO: Object 0x%p @offset=%tu\n",
-							p, p - addr);
+			pr_err("INFO: Object 0x%p @offset=%tu\n",
+				p, p - addr);
 			print_tracking(s, p);
 		}
 	}
@@ -2496,7 +2495,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 		list_del(&s->list);
 		up_write(&slub_lock);
 		if (kmem_cache_close(s)) {
-			printk(KERN_ERR "SLUB %s: %s called for cache that "
+			pr_err("SLUB %s: %s called for cache that "
 				"still has objects.\n", s->name, __func__);
 			dump_stack();
 		}
@@ -3090,8 +3089,7 @@ void __init kmem_cache_init(void)
 	kmem_size = sizeof(struct kmem_cache);
 #endif
 
-	printk(KERN_INFO
-		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
+	pr_info("SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" CPUs=%d, Nodes=%d\n",
 		caches, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
@@ -3380,16 +3378,16 @@ static void validate_slab_slab(struct kmem_cache *s, struct page *page,
 		validate_slab(s, page, map);
 		slab_unlock(page);
 	} else
-		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
+		pr_info("SLUB %s: Skipped busy slab 0x%p\n",
 			s->name, page);
 
 	if (s->flags & DEBUG_DEFAULT_FLAGS) {
 		if (!PageSlubDebug(page))
-			printk(KERN_ERR "SLUB %s: SlubDebug not set "
+			pr_err("SLUB %s: SlubDebug not set "
 				"on slab 0x%p\n", s->name, page);
 	} else {
 		if (PageSlubDebug(page))
-			printk(KERN_ERR "SLUB %s: SlubDebug set on "
+			pr_err("SLUB %s: SlubDebug set on "
 				"slab 0x%p\n", s->name, page);
 	}
 }
@@ -3408,7 +3406,7 @@ static int validate_slab_node(struct kmem_cache *s,
 		count++;
 	}
 	if (count != n->nr_partial)
-		printk(KERN_ERR "SLUB %s: %ld partial slabs counted but "
+		pr_err("SLUB %s: %ld partial slabs counted but "
 			"counter=%ld\n", s->name, count, n->nr_partial);
 
 	if (!(s->flags & SLAB_STORE_USER))
@@ -3419,7 +3417,7 @@ static int validate_slab_node(struct kmem_cache *s,
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs))
-		printk(KERN_ERR "SLUB: %s %ld slabs counted but "
+		pr_err("SLUB: %s %ld slabs counted but "
 			"counter=%ld\n", s->name, count,
 			atomic_long_read(&n->nr_slabs));
 
@@ -3453,53 +3451,49 @@ static void resiliency_test(void)
 {
 	u8 *p;
 
-	printk(KERN_ERR "SLUB resiliency testing\n");
-	printk(KERN_ERR "-----------------------\n");
-	printk(KERN_ERR "A. Corruption after allocation\n");
+	pr_err("SLUB resiliency testing\n");
+	pr_err("-----------------------\n");
+	pr_err("A. Corruption after allocation\n");
 
 	p = kzalloc(16, GFP_KERNEL);
 	p[16] = 0x12;
-	printk(KERN_ERR "\n1. kmalloc-16: Clobber Redzone/next pointer"
-			" 0x12->0x%p\n\n", p + 16);
+	pr_err("\n1. kmalloc-16: Clobber Redzone/next pointer"
+		" 0x12->0x%p\n\n", p + 16);
 
 	validate_slab_cache(kmalloc_caches + 4);
 
 	/* Hmmm... The next two are dangerous */
 	p = kzalloc(32, GFP_KERNEL);
 	p[32 + sizeof(void *)] = 0x34;
-	printk(KERN_ERR "\n2. kmalloc-32: Clobber next pointer/next slab"
-			" 0x34 -> -0x%p\n", p);
-	printk(KERN_ERR
-		"If allocated object is overwritten then not detectable\n\n");
+	pr_err("\n2. kmalloc-32: Clobber next pointer/next slab"
+		" 0x34 -> -0x%p\n", p);
+	pr_err("If allocated object is overwritten then not detectable\n\n");
 
 	validate_slab_cache(kmalloc_caches + 5);
 	p = kzalloc(64, GFP_KERNEL);
 	p += 64 + (get_cycles() & 0xff) * sizeof(void *);
 	*p = 0x56;
-	printk(KERN_ERR "\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n",
-									p);
-	printk(KERN_ERR
-		"If allocated object is overwritten then not detectable\n\n");
+	pr_err("\n3. kmalloc-64: corrupting random byte 0x56->0x%p\n", p);
+	pr_err("If allocated object is overwritten then not detectable\n\n");
 	validate_slab_cache(kmalloc_caches + 6);
 
-	printk(KERN_ERR "\nB. Corruption after free\n");
+	pr_err("\nB. Corruption after free\n");
 	p = kzalloc(128, GFP_KERNEL);
 	kfree(p);
 	*p = 0x78;
-	printk(KERN_ERR "1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
+	pr_err("1. kmalloc-128: Clobber first word 0x78->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches + 7);
 
 	p = kzalloc(256, GFP_KERNEL);
 	kfree(p);
 	p[50] = 0x9a;
-	printk(KERN_ERR "\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n",
-			p);
+	pr_err("\n2. kmalloc-256: Clobber 50th byte 0x9a->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches + 8);
 
 	p = kzalloc(512, GFP_KERNEL);
 	kfree(p);
 	p[512] = 0xab;
-	printk(KERN_ERR "\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
+	pr_err("\n3. kmalloc-512: Clobber redzone 0xab->0x%p\n\n", p);
 	validate_slab_cache(kmalloc_caches + 9);
 }
 #else
@@ -4492,7 +4486,7 @@ static int __init slab_sysfs_init(void)
 
 	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
 	if (!slab_kset) {
-		printk(KERN_ERR "Cannot register slab subsystem.\n");
+		pr_err("Cannot register slab subsystem.\n");
 		return -ENOSYS;
 	}
 
@@ -4501,8 +4495,8 @@ static int __init slab_sysfs_init(void)
 	list_for_each_entry(s, &slab_caches, list) {
 		err = sysfs_slab_add(s);
 		if (err)
-			printk(KERN_ERR "SLUB: Unable to add boot slab %s"
-						" to sysfs\n", s->name);
+			pr_err("SLUB: Unable to add boot slab %s"
+				" to sysfs\n", s->name);
 	}
 
 	while (alias_list) {
@@ -4511,8 +4505,8 @@ static int __init slab_sysfs_init(void)
 		alias_list = alias_list->next;
 		err = sysfs_slab_alias(al->s, al->name);
 		if (err)
-			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
-					" %s to sysfs\n", s->name);
+			pr_err("SLUB: Unable to add boot slab alias"
+				" %s to sysfs\n", s->name);
 		kfree(al);
 	}
 
