Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZCDJN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZCDJN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZCDJNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:13:44 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59698 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZCDJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:13:43 -0500
Subject: [PATCH] x86: move free_initrd_mem() to common mm/init.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Mar 2009 11:13:40 +0200
Message-Id: <1236158020.29024.28.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The function is identical on 32-bit and 64-bit configurations so move it to the
common mm/init.c file.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c    |    7 +++++++
 arch/x86/mm/init_32.c |    7 -------
 arch/x86/mm/init_64.c |    7 -------
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ce6a722..201bf4a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -47,3 +47,10 @@ void free_initmem(void)
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
 }
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	free_init_pages("initrd memory", start, end);
+}
+#endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0b087dc..d6bd5c4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1200,13 +1200,6 @@ void mark_rodata_ro(void)
 }
 #endif
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	free_init_pages("initrd memory", start, end);
-}
-#endif
-
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index aae8745..8df5919 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -983,13 +983,6 @@ void mark_rodata_ro(void)
 
 #endif
 
-#ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
-{
-	free_init_pages("initrd memory", start, end);
-}
-#endif
-
 int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
-- 
1.5.4.3



