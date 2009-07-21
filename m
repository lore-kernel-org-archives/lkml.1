Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZGUVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZGUVQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZGUVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:16:04 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54735 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZGUVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:57 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 05/10] arm: move mach-types to include/generated
Date: Tue, 21 Jul 2009 23:19:36 +0200
Message-Id: <1248211181-6757-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplified arch/arm/Makefile by dropping the maketools target
It was undocumented and not needed

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Makefile                 |   14 ++------------
 arch/arm/include/asm/mach-types.h |    1 +
 arch/arm/tools/Makefile           |    2 +-
 arch/arm/tools/gen-mach-types     |    2 +-
 4 files changed, 5 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/include/asm/mach-types.h

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c877d6d..8b335bf 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -226,15 +226,8 @@ all:	$(KBUILD_IMAGE)
 
 boot := arch/arm/boot
 
-#	Update machine arch and proc symlinks if something which affects
-#	them changed.  We use .arch to indicate when they were updated
-#	last, otherwise make uses the target directory mtime.
-
-archprepare: maketools
-
-PHONY += maketools FORCE
-maketools: include/linux/version.h FORCE
-	$(Q)$(MAKE) $(build)=arch/arm/tools include/asm-arm/mach-types.h
+archprepare:
+	$(Q)$(MAKE) $(build)=arch/arm/tools include/generated/mach-types.h
 
 # Convert bzImage to zImage
 bzImage: zImage
@@ -245,9 +238,6 @@ zImage Image xipImage bootpImage uImage: vmlinux
 zinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-CLEAN_FILES += include/asm-arm/mach-types.h \
-	       include/asm-arm/arch include/asm-arm/.arch
-
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
diff --git a/arch/arm/include/asm/mach-types.h b/arch/arm/include/asm/mach-types.h
new file mode 100644
index 0000000..948178c
--- /dev/null
+++ b/arch/arm/include/asm/mach-types.h
@@ -0,0 +1 @@
+#include <generated/mach-types.h>
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 1dbaa29..635cb18 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -4,7 +4,7 @@
 # Copyright (C) 2001 Russell King
 #
 
-include/asm-arm/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
+include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
diff --git a/arch/arm/tools/gen-mach-types b/arch/arm/tools/gen-mach-types
index ce319ef..04fef71 100644
--- a/arch/arm/tools/gen-mach-types
+++ b/arch/arm/tools/gen-mach-types
@@ -1,6 +1,6 @@
 #!/bin/awk
 #
-# Awk script to generate include/asm-arm/mach-types.h
+# Awk script to generate include/generated/mach-types.h
 #
 BEGIN	{ nr = 0 }
 /^#/	{ next }
-- 
1.6.2.5

