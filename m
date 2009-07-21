Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZGUVR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZGUVR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbZGUVRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:17:54 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54742 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZGUVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:57 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 07/10] kbuild: move compile.h to include/generated
Date: Tue, 21 Jul 2009 23:19:38 +0200
Message-Id: <1248211181-6757-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20090721211040.GA7688@merkur.ravnborg.org>
References: <20090721211040.GA7688@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 .gitignore              |    1 -
 arch/x86/boot/version.c |    2 +-
 init/Makefile           |    6 +++---
 init/version.c          |    2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index 624e3ab..0f594d9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -46,7 +46,6 @@ Module.symvers
 #
 include/config
 include/linux/autoconf.h
-include/linux/compile.h
 include/linux/version.h
 include/linux/utsrelease.h
 include/generated
diff --git a/arch/x86/boot/version.c b/arch/x86/boot/version.c
index 2723d9b..4d88763 100644
--- a/arch/x86/boot/version.c
+++ b/arch/x86/boot/version.c
@@ -14,7 +14,7 @@
 
 #include "boot.h"
 #include <linux/utsrelease.h>
-#include <linux/compile.h>
+#include <generated/compile.h>
 
 const char kernel_version[] =
 	UTS_RELEASE " (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ") "
diff --git a/init/Makefile b/init/Makefile
index 4a243df..2bcd810 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -16,11 +16,11 @@ mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
 
 # files to be removed upon make clean
-clean-files := ../include/linux/compile.h
+clean-files := ../include/generated/compile.h
 
 # dependencies on generated files need to be listed explicitly
 
-$(obj)/version.o: include/linux/compile.h
+$(obj)/version.o: include/generated/compile.h
 
 # compile.h changes depending on hostname, generation number, etc,
 # so we regenerate it always.
@@ -30,7 +30,7 @@ $(obj)/version.o: include/linux/compile.h
        chk_compile.h = :
  quiet_chk_compile.h = echo '  CHK     $@'
 silent_chk_compile.h = :
-include/linux/compile.h: FORCE
+include/generated/compile.h: FORCE
 	@$($(quiet)chk_compile.h)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkcompile_h $@ \
 	"$(UTS_MACHINE)" "$(CONFIG_SMP)" "$(CONFIG_PREEMPT)" "$(CC) $(KBUILD_CFLAGS)"
diff --git a/init/version.c b/init/version.c
index 52a8b98..82328aa 100644
--- a/init/version.c
+++ b/init/version.c
@@ -6,7 +6,7 @@
  *  May be freely distributed as part of Linux.
  */
 
-#include <linux/compile.h>
+#include <generated/compile.h>
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
-- 
1.6.2.5

