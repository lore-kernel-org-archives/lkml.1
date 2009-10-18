Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZJRIML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZJRIML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZJRIMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:12:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50939 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJRILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:21 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 14/14] kbuild: move utsrelease.h to include/generated
Date: Sun, 18 Oct 2009 10:15:23 +0200
Message-Id: <1255853723-477-14-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up all users of utsrelease.h

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 .gitignore                                   |    1 -
 Makefile                                     |    5 ++---
 arch/alpha/boot/bootp.c                      |    2 +-
 arch/alpha/boot/bootpz.c                     |    2 +-
 arch/alpha/boot/main.c                       |    2 +-
 arch/frv/kernel/setup.c                      |    2 +-
 arch/powerpc/platforms/52xx/efika.c          |    2 +-
 arch/powerpc/platforms/amigaone/setup.c      |    2 +-
 arch/powerpc/platforms/chrp/setup.c          |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c |    2 +-
 arch/x86/boot/header.S                       |    2 +-
 arch/x86/boot/version.c                      |    2 +-
 drivers/staging/panel/panel.c                |    2 +-
 include/linux/vermagic.h                     |    2 +-
 init/version.c                               |    2 +-
 kernel/kexec.c                               |    2 +-
 kernel/trace/trace.c                         |    2 +-
 17 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/.gitignore b/.gitignore
index 91f8e0c..4980606 100644
--- a/.gitignore
+++ b/.gitignore
@@ -46,7 +46,6 @@ Module.symvers
 #
 include/config
 include/linux/version.h
-include/linux/utsrelease.h
 include/generated
 
 # stgit generated dirs
diff --git a/Makefile b/Makefile
index b125cd9..3ee1c81 100644
--- a/Makefile
+++ b/Makefile
@@ -967,7 +967,7 @@ endif
 # prepare2 creates a makefile if using a separate output directory
 prepare2: prepare3 outputmakefile
 
-prepare1: prepare2 include/linux/version.h include/linux/utsrelease.h \
+prepare1: prepare2 include/linux/version.h include/generated/utsrelease.h \
                    include/config/auto.conf
 	$(cmd_crmodverdir)
 
@@ -1004,7 +1004,7 @@ endef
 include/linux/version.h: $(srctree)/Makefile FORCE
 	$(call filechk,version.h)
 
-include/linux/utsrelease.h: include/config/kernel.release FORCE
+include/generated/utsrelease.h: include/config/kernel.release FORCE
 	$(call filechk,utsrelease.h)
 
 PHONY += headerdep
@@ -1150,7 +1150,6 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config usr/include include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
-                  include/linux/utsrelease.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
diff --git a/arch/alpha/boot/bootp.c b/arch/alpha/boot/bootp.c
index 3af21c7..3c8d1b2 100644
--- a/arch/alpha/boot/bootp.c
+++ b/arch/alpha/boot/bootp.c
@@ -9,7 +9,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/mm.h>
 
 #include <asm/system.h>
diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index 1036b51..ade3f12 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -11,7 +11,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/mm.h>
 
 #include <asm/system.h>
diff --git a/arch/alpha/boot/main.c b/arch/alpha/boot/main.c
index 89f3be0..644b7db 100644
--- a/arch/alpha/boot/main.c
+++ b/arch/alpha/boot/main.c
@@ -7,7 +7,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/mm.h>
 
 #include <asm/system.h>
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 55e4fab..75cf7f4 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -10,7 +10,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
index bcc69e1..45c0cb9 100644
--- a/arch/powerpc/platforms/52xx/efika.c
+++ b/arch/powerpc/platforms/52xx/efika.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/init.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/pci.h>
 #include <linux/of.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/amigaone/setup.c b/arch/powerpc/platforms/amigaone/setup.c
index 9290a7a..fb4eb0d 100644
--- a/arch/powerpc/platforms/amigaone/setup.c
+++ b/arch/powerpc/platforms/amigaone/setup.c
@@ -14,7 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/seq_file.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 
 #include <asm/machdep.h>
 #include <asm/cputable.h>
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index cd4ad9a..0a6f5ab 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -23,7 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/adb.h>
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index cf66091..9dd789a 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/page.h>
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index b31cc54..93e689f 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -16,7 +16,7 @@
  */
 
 #include <asm/segment.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <asm/boot.h>
 #include <asm/e820.h>
 #include <asm/page_types.h>
diff --git a/arch/x86/boot/version.c b/arch/x86/boot/version.c
index 4d88763..2b15aa4 100644
--- a/arch/x86/boot/version.c
+++ b/arch/x86/boot/version.c
@@ -13,7 +13,7 @@
  */
 
 #include "boot.h"
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <generated/compile.h>
 
 const char kernel_version[] =
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index dd7d3fd..51e94a1 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -55,7 +55,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 
 #include <linux/io.h>
 #include <asm/uaccess.h>
diff --git a/include/linux/vermagic.h b/include/linux/vermagic.h
index 79b9837..cf97b5b 100644
--- a/include/linux/vermagic.h
+++ b/include/linux/vermagic.h
@@ -1,4 +1,4 @@
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/module.h>
 
 /* Simply sanity version stamp for modules. */
diff --git a/init/version.c b/init/version.c
index 82328aa..adff586 100644
--- a/init/version.c
+++ b/init/version.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/version.h>
 
 #ifndef CONFIG_KALLSYMS
diff --git a/kernel/kexec.c b/kernel/kexec.c
index f336e21..83f54e2 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -21,7 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c820b03..565eccf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -12,7 +12,7 @@
  *  Copyright (C) 2004 William Lee Irwin III
  */
 #include <linux/ring_buffer.h>
-#include <linux/utsrelease.h>
+#include <generated/utsrelease.h>
 #include <linux/stacktrace.h>
 #include <linux/writeback.h>
 #include <linux/kallsyms.h>
-- 
1.6.2.5

