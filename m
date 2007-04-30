Return-Path: <linux-kernel-owner+w=401wt.eu-S1423439AbXD3P4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423439AbXD3P4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423441AbXD3P4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:56:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:34341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423439AbXD3Ptl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/34] x86_64: Move mtrr prototypes from proto.h to mtrr.h
Message-Id: <20070430154932.B6F01151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/mtrr.h  |    8 ++++++++
 include/asm-x86_64/proto.h |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

Index: linux/include/asm-x86_64/mtrr.h
===================================================================
--- linux.orig/include/asm-x86_64/mtrr.h
+++ linux/include/asm-x86_64/mtrr.h
@@ -135,6 +135,14 @@ struct mtrr_gentry32
 
 #endif /* CONFIG_COMPAT */
 
+#ifdef CONFIG_MTRR
+extern void mtrr_ap_init(void);
+extern void mtrr_bp_init(void);
+#else
+#define mtrr_ap_init() do {} while (0)
+#define mtrr_bp_init() do {} while (0)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif  /*  _LINUX_MTRR_H  */
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -14,13 +14,6 @@ extern void pda_init(int); 
 extern void early_idt_handler(void);
 
 extern void mcheck_init(struct cpuinfo_x86 *c);
-#ifdef CONFIG_MTRR
-extern void mtrr_ap_init(void);
-extern void mtrr_bp_init(void);
-#else
-#define mtrr_ap_init() do {} while (0)
-#define mtrr_bp_init() do {} while (0)
-#endif
 extern void init_memory_mapping(unsigned long start, unsigned long end);
 
 extern void system_call(void); 
