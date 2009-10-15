Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbZJOG1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbZJOG1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZJOG1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbZJOG1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:27:35 -0400
Date: Thu, 15 Oct 2009 02:27:00 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Message-Id: <20091015062942.4391.22306.sendpatchset@localhost.localdomain>
Subject: [Patch] kallsyms: remove deprecated print_fn_descriptor_symbol()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


According to feature-removal-schedule.txt, it is the time
to remove print_fn_descriptor_symbol().

And a quick grep shows that it no longer has any callers.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 04e6c81..42ba573 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -283,15 +283,6 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
-What: print_fn_descriptor_symbol()
-When: October 2009
-Why:  The %pF vsprintf format provides the same functionality in a
-      simpler way.  print_fn_descriptor_symbol() is deprecated but
-      still present to give out-of-tree modules time to change.
-Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
-
----------------------------
-
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 7922742..d8e9b3d 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -107,18 +107,6 @@ static inline void print_symbol(const char *fmt, unsigned long addr)
 		       __builtin_extract_return_addr((void *)addr));
 }
 
-/*
- * Pretty-print a function pointer.  This function is deprecated.
- * Please use the "%pF" vsprintf format instead.
- */
-static inline void __deprecated print_fn_descriptor_symbol(const char *fmt, void *addr)
-{
-#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
-	addr = *(void **)addr;
-#endif
-	print_symbol(fmt, (unsigned long)addr);
-}
-
 static inline void print_ip_sym(unsigned long ip)
 {
 	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
