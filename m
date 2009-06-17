Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZFQQWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZFQQWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZFQQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:22:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33999 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZFQQWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:22:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, rgetz@blackfin.uclinux.org, akpm@linux-foundation.org
Subject: [PATCH 1/4] asm/sections: add text/data checking functions for arches to override
Date: Wed, 17 Jun 2009 12:22:21 -0400
Message-Id: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ports (like the Blackfin arch) have a discontiguous memory map which
means there may be text or data that falls outside of the standard range
of the start/end text/data symbols.  Creating some helper functions allows
these non-standard ports to declare these regions without adversely
affecting anyone else.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/sections.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index 4ce48e8..ee19462 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -20,4 +20,20 @@ extern char __start_rodata[], __end_rodata[];
 #define dereference_function_descriptor(p) (p)
 #endif
 
+/* random extra sections (if any).  Override
+ * in asm/sections.h */
+#ifndef arch_is_kernel_text
+static inline int arch_is_kernel_text(unsigned long addr)
+{
+	return 0;
+}
+#endif
+
+#ifndef arch_is_kernel_data
+static inline int arch_is_kernel_data(unsigned long addr)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_GENERIC_SECTIONS_H_ */
-- 
1.6.3.1

