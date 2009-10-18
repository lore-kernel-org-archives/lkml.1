Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZJRINz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZJRINz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZJRINx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:13:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50920 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZJRILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 07/14] sh: move machtypes.h to include/generated
Date: Sun, 18 Oct 2009 10:15:16 +0200
Message-Id: <1255853723-477-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sh/Makefile                        |   10 +++-------
 arch/sh/drivers/pci/fixups-rts7751r2d.c |    2 +-
 arch/sh/include/asm/.gitignore          |    1 -
 arch/sh/include/asm/machvec.h           |    2 +-
 arch/sh/tools/Makefile                  |    4 ++--
 arch/sh/tools/gen-mach-types            |    2 +-
 6 files changed, 8 insertions(+), 13 deletions(-)
 delete mode 100644 arch/sh/include/asm/.gitignore

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index fc51a91..d1dc2f4 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -201,10 +201,7 @@ libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
 
 BOOT_TARGETS = uImage uImage.bz2 uImage.gz uImage.lzma uImage.srec \
 	       zImage vmlinux.srec romImage
-PHONY += maketools $(BOOT_TARGETS) FORCE
-
-maketools:  include/linux/version.h FORCE
-	$(Q)$(MAKE) $(build)=arch/sh/tools include/asm-sh/machtypes.h
+PHONY += $(BOOT_TARGETS)
 
 all: $(KBUILD_IMAGE)
 
@@ -213,7 +210,8 @@ $(BOOT_TARGETS): vmlinux
 
 compressed: zImage
 
-archprepare: maketools
+archprepare:
+	$(Q)$(MAKE) $(build)=arch/sh/tools include/generated/machtypes.h
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
@@ -229,5 +227,3 @@ define archhelp
 	@echo '  uImage.bz2	           - Kernel-only image for U-Boot (bzip2)'
 	@echo '  uImage.lzma	           - Kernel-only image for U-Boot (lzma)'
 endef
-
-CLEAN_FILES += include/asm-sh/machtypes.h
diff --git a/arch/sh/drivers/pci/fixups-rts7751r2d.c b/arch/sh/drivers/pci/fixups-rts7751r2d.c
index 052b354..7898f14 100644
--- a/arch/sh/drivers/pci/fixups-rts7751r2d.c
+++ b/arch/sh/drivers/pci/fixups-rts7751r2d.c
@@ -15,7 +15,7 @@
 #include <mach/lboxre2.h>
 #include <mach/r2d.h>
 #include "pci-sh4.h"
-#include <asm/machtypes.h>
+#include <generated/machtypes.h>
 
 #define PCIMCR_MRSET_OFF	0xBFFFFFFF
 #define PCIMCR_RFSH_OFF		0xFFFFFFFB
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

