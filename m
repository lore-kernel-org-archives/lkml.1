Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbXCaN7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbXCaN7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXCaN7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:59:24 -0400
Received: from verein.lst.de ([213.95.11.210]:52584 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbXCaN7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:59:23 -0400
Date: Sat, 31 Mar 2007 15:59:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] kprobes: codingstyle cleanups
Message-ID: <20070331135925.GB17406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superflous braces and fix indentation aswell as comments.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/kernel/kprobes.c	2007-03-31 14:48:57.000000000 +0200
+++ linux-2.6/kernel/kprobes.c	2007-03-31 14:49:07.000000000 +0200
@@ -132,7 +132,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
 
-      retry:
+ retry:
 	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
@@ -154,9 +154,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	}
 	/* All out of space.  Need to allocate a new page. Use slot 0. */
 	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
-	if (!kip) {
+	if (!kip)
 		return NULL;
-	}
 
 	/*
 	 * Use module_alloc so this page is within +/- 2GB of where the
@@ -245,9 +244,9 @@ void __kprobes free_insn_slot(kprobe_opc
 			break;
 		}
 	}
-	if (dirty && (++kprobe_garbage_slots > INSNS_PER_PAGE)) {
+
+	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
 		collect_garbage_slots();
-	}
 }
 #endif
 
@@ -313,7 +312,6 @@ static void __kprobes aggr_post_handler(
 			reset_kprobe_instance();
 		}
 	}
-	return;
 }
 
 static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
@@ -532,8 +530,8 @@ static int __kprobes register_aggr_kprob
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
-	if (addr >= (unsigned long)__kprobes_text_start
-		&& addr < (unsigned long)__kprobes_text_end)
+	if (addr >= (unsigned long)__kprobes_text_start &&
+	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
 	return 0;
 }
@@ -560,19 +558,24 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
 
-	if ((!kernel_text_address((unsigned long) p->addr)) ||
-		in_kprobes_functions((unsigned long) p->addr))
+	if (!kernel_text_address((unsigned long) p->addr) ||
+	    in_kprobes_functions((unsigned long) p->addr))
 		return -EINVAL;
 
 	p->mod_refcounted = 0;
-	/* Check are we probing a module */
-	if ((probed_mod = module_text_address((unsigned long) p->addr))) {
+
+	/*
+	 * Check if are we probing a module.
+	 */
+	probed_mod = module_text_address((unsigned long) p->addr);
+	if (probed_mod) {
 		struct module *calling_mod = module_text_address(called_from);
-		/* We must allow modules to probe themself and
-		 * in this case avoid incrementing the module refcount,
-		 * so as to allow unloading of self probing modules.
+		/*
+		 * We must allow modules to probe themself and in this case
+		 * avoid incrementing the module refcount, so as to allow
+		 * unloading of self probing modules.
 		 */
-		if (calling_mod && (calling_mod != probed_mod)) {
+		if (calling_mod && calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod)))
 				return -EINVAL;
 			p->mod_refcounted = 1;
@@ -590,7 +593,8 @@ static int __kprobes __register_kprobe(s
 		goto out;
 	}
 
-	if ((ret = arch_prepare_kprobe(p)) != 0)
+	ret = arch_prepare_kprobe(p);
+	if (ret)
 		goto out;
 
 	INIT_HLIST_NODE(&p->hlist);
@@ -613,8 +617,7 @@ out:
 
 int __kprobes register_kprobe(struct kprobe *p)
 {
-	return __register_kprobe(p,
-		(unsigned long)__builtin_return_address(0));
+	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
 }
 
 void __kprobes unregister_kprobe(struct kprobe *p)
@@ -638,9 +641,9 @@ void __kprobes unregister_kprobe(struct 
 		return;
 	}
 valid_p:
-	if ((old_p == p) || ((old_p->pre_handler == aggr_pre_handler) &&
-		(p->list.next == &old_p->list) &&
-		(p->list.prev == &old_p->list))) {
+	if (old_p == p ||
+	    (old_p->pre_handler == aggr_pre_handler &&
+	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
 		/* Only probe on the hash list */
 		arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
@@ -653,9 +656,11 @@ valid_p:
 	mutex_unlock(&kprobe_mutex);
 
 	synchronize_sched();
-	if (p->mod_refcounted &&
-	    (mod = module_text_address((unsigned long)p->addr)))
-		module_put(mod);
+	if (p->mod_refcounted) {
+		mod = module_text_address((unsigned long)p->addr);
+		if (mod)
+			module_put(mod);
+	}
 
 	if (cleanup_p) {
 		if (p != old_p) {
