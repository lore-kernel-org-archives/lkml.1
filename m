Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZGUVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZGUVP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZGUVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:15:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54725 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZGUVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:56 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 03/10] ia64: move nr-irqs.h to include/generated
Date: Tue, 21 Jul 2009 23:19:34 +0200
Message-Id: <1248211181-6757-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid generating files in the now deprecated asm-ia64 dir
Simplified the logic in the Makefile when editing stuff in the area

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/Makefile          |    2 +-
 arch/ia64/include/asm/irq.h |    2 +-
 arch/ia64/kernel/Makefile   |    7 ++-----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 58a7e46..e9fcac6 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -108,4 +108,4 @@ archprepare: make_nr_irqs_h FORCE
 PHONY += make_nr_irqs_h FORCE
 
 make_nr_irqs_h: FORCE
-	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/asm-ia64/nr-irqs.h
+	$(Q)$(MAKE) $(build)=arch/ia64/kernel include/generated/nr-irqs.h
diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
index 5282546..91b920f 100644
--- a/arch/ia64/include/asm/irq.h
+++ b/arch/ia64/include/asm/irq.h
@@ -13,7 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/cpumask.h>
-#include <asm-ia64/nr-irqs.h>
+#include <generated/nr-irqs.h>
 
 static __inline__ int
 irq_canonicalize (int irq)
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 6b7edca..cedd773 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -81,17 +81,14 @@ define cmd_nr_irqs
 endef
 
 # We use internal kbuild rules to avoid the "is up to date" message from make
-arch/$(SRCARCH)/kernel/nr-irqs.s: $(srctree)/arch/$(SRCARCH)/kernel/nr-irqs.c \
-				$(wildcard $(srctree)/include/asm-ia64/*/irq.h)
+arch/ia64/kernel/nr-irqs.s: arch/ia64/kernel/nr-irqs.c
 	$(Q)mkdir -p $(dir $@)
 	$(call if_changed_dep,cc_s_c)
 
-include/asm-ia64/nr-irqs.h: arch/$(SRCARCH)/kernel/nr-irqs.s
+include/generated/nr-irqs.h: arch/ia64/kernel/nr-irqs.s
 	$(Q)mkdir -p $(dir $@)
 	$(call cmd,nr_irqs)
 
-clean-files += $(objtree)/include/asm-ia64/nr-irqs.h
-
 #
 # native ivt.S, entry.S and fsys.S
 #
-- 
1.6.2.5

