Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbZJGJuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbZJGJuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZJGJue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:50:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:57449 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751199AbZJGJud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:50:33 -0400
X-Authenticated: #20192376
X-Provags-ID: V01U2FsdGVkX1/6IZsRwmb6Ef0vE0T5laZfKLfMfXuucFndByNMbp
	Nag5h/r09w8ZVg
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       linux-am33-list@redhat.com, liqin.chen@sunplusct.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/1] Make totalhigh_pages unsigned long.
Date: Wed,  7 Oct 2009 11:49:37 +0200
Message-Id: <1254908977-12827-2-git-send-email-andreas.fenkart@streamunlimited.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254908977-12827-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <1254908977-12827-1-git-send-email-andreas.fenkart@streamunlimited.com>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it consistent with the extern declaration, used when
CONFIG_HIGHMEM is set
Removes redundant casts in printout messages

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 arch/arm/mm/init.c               |    2 +-
 arch/mips/mm/init.c              |    2 +-
 arch/mips/sgi-ip27/ip27-memory.c |    2 +-
 arch/mn10300/mm/init.c           |    3 +--
 arch/score/mm/init.c             |    2 +-
 arch/x86/mm/init_32.c            |    3 +--
 include/linux/highmem.h          |    2 +-
 7 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 877c492..8d76b50 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -598,7 +598,7 @@ void __init mem_init(void)
 		"%dK data, %dK init, %luK highmem)\n",
 		nr_free_pages() << (PAGE_SHIFT-10), codesize >> 10,
 		datasize >> 10, initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+		totalhigh_pages << (PAGE_SHIFT-10));
 
 	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {
 		extern int sysctl_overcommit_memory;
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 15aa190..03ac816 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -420,7 +420,7 @@ void __init mem_init(void)
 	       reservedpages << (PAGE_SHIFT-10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+	       totalhigh_pages << (PAGE_SHIFT-10));
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
diff --git a/arch/mips/sgi-ip27/ip27-memory.c b/arch/mips/sgi-ip27/ip27-memory.c
index f61c164..bc12971 100644
--- a/arch/mips/sgi-ip27/ip27-memory.c
+++ b/arch/mips/sgi-ip27/ip27-memory.c
@@ -505,5 +505,5 @@ void __init mem_init(void)
 	       (num_physpages - tmp) << (PAGE_SHIFT-10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+	       totalhigh_pages << (PAGE_SHIFT-10));
 }
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index ec14205..dd27a9a 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -118,8 +118,7 @@ void __init mem_init(void)
 	       reservedpages << (PAGE_SHIFT - 10),
 	       datasize >> 10,
 	       initsize >> 10,
-	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT - 10))
-	       );
+	       totalhigh_pages << (PAGE_SHIFT - 10));
 }
 
 /*
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index 4e3dcd0..3739a41 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -111,7 +111,7 @@ void __init mem_init(void)
 			ram << (PAGE_SHIFT-10), codesize >> 10,
 			reservedpages << (PAGE_SHIFT-10), datasize >> 10,
 			initsize >> 10,
-			(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
+			totalhigh_pages << (PAGE_SHIFT-10));
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 30938c1..b1738d1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -892,8 +892,7 @@ void __init mem_init(void)
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
-	       );
+		totalhigh_pages << (PAGE_SHIFT-10));
 
 	printk(KERN_INFO "virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 211ff44..ab2cc20 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -46,7 +46,7 @@ void kmap_flush_unused(void);
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
-#define totalhigh_pages 0
+#define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
-- 
1.6.4.3

