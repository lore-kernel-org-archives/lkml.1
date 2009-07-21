Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZGUVQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZGUVQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbZGUVQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:16:00 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54729 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZGUVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:56 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 04/10] sh: move machtypes.h to include/generated
Date: Tue, 21 Jul 2009 23:19:35 +0200
Message-Id: <1248211181-6757-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Makefile               |    9 ++-------
 arch/sh/include/asm/.gitignore |    1 -
 arch/sh/include/asm/machvec.h  |    2 +-
 arch/sh/tools/Makefile         |    4 ++--
 arch/sh/tools/gen-mach-types   |    2 +-
 5 files changed, 6 insertions(+), 12 deletions(-)
 delete mode 100644 arch/sh/include/asm/.gitignore

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 75d049b..1b63cfd 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -189,10 +189,6 @@ KBUILD_AFLAGS		+= $(cflags-y)
 libs-$(CONFIG_SUPERH32)		:= arch/sh/lib/	$(libs-y)
 libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
 
-PHONY += maketools FORCE
-
-maketools:  include/linux/version.h FORCE
-	$(Q)$(MAKE) $(build)=arch/sh/tools include/asm-sh/machtypes.h
 
 all: $(KBUILD_IMAGE)
 
@@ -201,7 +197,8 @@ zImage uImage uImage.srec vmlinux.srec: vmlinux
 
 compressed: zImage
 
-archprepare: maketools
+archprepare:
+	$(Q)$(MAKE) $(build)=arch/sh/tools include/asm-sh/machtypes.h
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
@@ -213,5 +210,3 @@ define archhelp
 	@echo '  uImage  	           - Create a bootable image for U-Boot'
 	@echo '  uImage.srec  	           - Create an S-record for U-Boot'
 endef
-
-CLEAN_FILES += include/asm-sh/machtypes.h
diff --git a/arch/sh/include/asm/.gitignore b/arch/sh/include/asm/.gitignore
deleted file mode 100644
index 378db77..0000000
--- a/arch/sh/include/asm/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-machtypes.h
diff --git a/arch/sh/include/asm/machvec.h b/arch/sh/include/asm/machvec.h
index 84dd377..9c30955 100644
--- a/arch/sh/include/asm/machvec.h
+++ b/arch/sh/include/asm/machvec.h
@@ -12,7 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/time.h>
-#include <asm/machtypes.h>
+#include <generated/machtypes.h>
 
 struct sh_machine_vector {
 	void (*mv_setup)(char **cmdline_p);
diff --git a/arch/sh/tools/Makefile b/arch/sh/tools/Makefile
index 567516b..558a56b 100644
--- a/arch/sh/tools/Makefile
+++ b/arch/sh/tools/Makefile
@@ -10,7 +10,7 @@
 # Shamelessly cloned from ARM.
 #
 
-include/asm-sh/machtypes.h: $(src)/gen-mach-types $(src)/mach-types
+include/generated/machtypes.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
-	$(Q)if [ ! -d include/asm-sh ]; then mkdir -p include/asm-sh; fi
+	$(Q)mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
diff --git a/arch/sh/tools/gen-mach-types b/arch/sh/tools/gen-mach-types
index 65161e3..f5ff7c5 100644
--- a/arch/sh/tools/gen-mach-types
+++ b/arch/sh/tools/gen-mach-types
@@ -1,6 +1,6 @@
 #!/bin/awk
 #
-# Awk script to generate include/asm-sh/machtypes.h
+# Awk script to generate include/generated/machtypes.h
 # Heavily based on arch/arm/tools/gen-mach-types
 #
 BEGIN	{ nr = 0 }
-- 
1.6.2.5

