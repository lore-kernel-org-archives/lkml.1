Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZGUVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZGUVQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbZGUVQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:16:02 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54717 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZGUVP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:56 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 02/10] kbuild: move asm-offsets.h to include/generated
Date: Tue, 21 Jul 2009 23:19:33 +0200
Message-Id: <1248211181-6757-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simplest method was to add an extra asm-offsets.h
file in arch/$ARCH/include/asm that references the generated file.

We can now migrate the architectures one-by-one to reference
the generated file direct - and when done we can delete the
temporary arch/$ARCH/include/asm/asm-offsets.h file.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 .gitignore                                |    1 -
 Kbuild                                    |    2 +-
 Makefile                                  |    1 -
 arch/alpha/include/asm/asm-offsets.h      |    1 +
 arch/arm/include/asm/asm-offsets.h        |    1 +
 arch/avr32/include/asm/asm-offsets.h      |    1 +
 arch/blackfin/include/asm/asm-offsets.h   |    1 +
 arch/cris/include/asm/asm-offsets.h       |    1 +
 arch/frv/include/asm/asm-offsets.h        |    1 +
 arch/h8300/include/asm/asm-offsets.h      |    1 +
 arch/ia64/include/asm/asm-offsets.h       |    1 +
 arch/m68k/include/asm/asm-offsets.h       |    1 +
 arch/microblaze/include/asm/asm-offsets.h |    1 +
 arch/mips/include/asm/asm-offsets.h       |    1 +
 arch/mn10300/include/asm/asm-offsets.h    |    1 +
 arch/parisc/include/asm/asm-offsets.h     |    1 +
 arch/powerpc/include/asm/asm-offsets.h    |    1 +
 arch/s390/include/asm/asm-offsets.h       |    1 +
 arch/sh/include/asm/asm-offsets.h         |    1 +
 arch/sparc/include/asm/asm-offsets.h      |    1 +
 arch/um/Makefile                          |    2 +-
 arch/um/include/asm/asm-offsets.h         |    1 +
 arch/x86/include/asm/asm-offsets.h        |    1 +
 arch/xtensa/include/asm/asm-offsets.h     |    1 +
 24 files changed, 22 insertions(+), 4 deletions(-)
 create mode 100644 arch/alpha/include/asm/asm-offsets.h
 create mode 100644 arch/arm/include/asm/asm-offsets.h
 create mode 100644 arch/avr32/include/asm/asm-offsets.h
 create mode 100644 arch/blackfin/include/asm/asm-offsets.h
 create mode 100644 arch/cris/include/asm/asm-offsets.h
 create mode 100644 arch/frv/include/asm/asm-offsets.h
 create mode 100644 arch/h8300/include/asm/asm-offsets.h
 create mode 100644 arch/ia64/include/asm/asm-offsets.h
 create mode 100644 arch/m68k/include/asm/asm-offsets.h
 create mode 100644 arch/microblaze/include/asm/asm-offsets.h
 create mode 100644 arch/mips/include/asm/asm-offsets.h
 create mode 100644 arch/mn10300/include/asm/asm-offsets.h
 create mode 100644 arch/parisc/include/asm/asm-offsets.h
 create mode 100644 arch/powerpc/include/asm/asm-offsets.h
 create mode 100644 arch/s390/include/asm/asm-offsets.h
 create mode 100644 arch/sh/include/asm/asm-offsets.h
 create mode 100644 arch/sparc/include/asm/asm-offsets.h
 create mode 100644 arch/um/include/asm/asm-offsets.h
 create mode 100644 arch/x86/include/asm/asm-offsets.h
 create mode 100644 arch/xtensa/include/asm/asm-offsets.h

diff --git a/.gitignore b/.gitignore
index 32855c6..5a5024a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -45,7 +45,6 @@ Module.symvers
 # Generated include files
 #
 include/asm
-include/asm-*/asm-offsets.h
 include/config
 include/linux/autoconf.h
 include/linux/compile.h
diff --git a/Kbuild b/Kbuild
index 1165d7a..e3737ad 100644
--- a/Kbuild
+++ b/Kbuild
@@ -43,7 +43,7 @@ $(obj)/$(bounds-file): kernel/bounds.s Kbuild
 # 2) Generate asm-offsets.h
 #
 
-offsets-file := include/asm/asm-offsets.h
+offsets-file := include/generated/asm-offsets.h
 
 always  += $(offsets-file)
 targets += $(offsets-file)
diff --git a/Makefile b/Makefile
index 9bd427e..1f6a34c 100644
--- a/Makefile
+++ b/Makefile
@@ -1197,7 +1197,6 @@ MRPROPER_DIRS  += include/config include2 usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-                  include/asm*/asm-offsets.h                            \
 		  Module.symvers Module.markers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
diff --git a/arch/alpha/include/asm/asm-offsets.h b/arch/alpha/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/alpha/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/arm/include/asm/asm-offsets.h b/arch/arm/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/arm/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/avr32/include/asm/asm-offsets.h b/arch/avr32/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/avr32/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/blackfin/include/asm/asm-offsets.h b/arch/blackfin/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/blackfin/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/cris/include/asm/asm-offsets.h b/arch/cris/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/cris/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/frv/include/asm/asm-offsets.h b/arch/frv/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/frv/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/h8300/include/asm/asm-offsets.h b/arch/h8300/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/h8300/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/ia64/include/asm/asm-offsets.h b/arch/ia64/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/ia64/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/m68k/include/asm/asm-offsets.h b/arch/m68k/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/m68k/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/microblaze/include/asm/asm-offsets.h b/arch/microblaze/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/microblaze/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/mips/include/asm/asm-offsets.h b/arch/mips/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/mips/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/mn10300/include/asm/asm-offsets.h b/arch/mn10300/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/mn10300/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/parisc/include/asm/asm-offsets.h b/arch/parisc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/parisc/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/powerpc/include/asm/asm-offsets.h b/arch/powerpc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/powerpc/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/s390/include/asm/asm-offsets.h b/arch/s390/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/s390/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/sh/include/asm/asm-offsets.h b/arch/sh/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/sh/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/sparc/include/asm/asm-offsets.h b/arch/sparc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/sparc/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..8936057 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -150,6 +150,6 @@ $(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 
 $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)mkdir -p $(dir $@)
-	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
+	$(Q)echo '#include "../../../../include/generated/asm-offsets.h"' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
diff --git a/arch/um/include/asm/asm-offsets.h b/arch/um/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/um/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/x86/include/asm/asm-offsets.h b/arch/x86/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/x86/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/xtensa/include/asm/asm-offsets.h b/arch/xtensa/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/xtensa/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
-- 
1.6.2.5

