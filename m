Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbZJRIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZJRIOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZJRINz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:13:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50916 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbZJRILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 06/14] arm: move mach-types to include/generated
Date: Sun, 18 Oct 2009 10:15:15 +0200
Message-Id: <1255853723-477-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
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
index a73caaf..90b9704 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -239,15 +239,8 @@ all:	$(KBUILD_IMAGE)
 
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
@@ -258,9 +251,6 @@ zImage Image xipImage bootpImage uImage: vmlinux
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

