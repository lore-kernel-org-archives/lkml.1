Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZJRIN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZJRIN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZJRINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:13:54 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50922 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZJRILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:19 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 08/14] kbuild: drop include2/ used for O=... builds
Date: Sun, 18 Oct 2009 10:15:17 +0200
Message-Id: <1255853723-477-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no longer any use of the include2/ directory.
The generated files has moved to include/generated.

Drop all references to said directory.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile                                   |    9 ++-------
 arch/powerpc/platforms/cell/spufs/Makefile |    6 ++----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 6c60a84..63dc381 100644
--- a/Makefile
+++ b/Makefile
@@ -335,7 +335,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 # Use LINUXINCLUDE when you must reference the include/ directory.
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
-                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
+                   $(if $(KBUILD_SRC), -I$(srctree)/include) \
                    -include include/linux/autoconf.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__
@@ -953,7 +953,6 @@ PHONY += prepare archprepare prepare0 prepare1 prepare2 prepare3
 # prepare3 is used to check if we are building in a separate output directory,
 # and if so do:
 # 1) Check that make has not been executed in the kernel src $(srctree)
-# 2) Create the include2 directory, used for the second asm symlink
 prepare3: include/config/kernel.release
 ifneq ($(KBUILD_SRC),)
 	@$(kecho) '  Using $(srctree) as source for kernel'
@@ -962,10 +961,6 @@ ifneq ($(KBUILD_SRC),)
 		echo "  in the '$(srctree)' directory.";\
 		/bin/false; \
 	fi;
-	$(Q)if [ ! -d include2 ]; then                                  \
-	    mkdir -p include2;                                          \
-	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
-	fi
 endif
 
 # prepare2 creates a makefile if using a separate output directory
@@ -1192,7 +1187,7 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include include/generated
+MRPROPER_DIRS  += include/config usr/include include/generated
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
diff --git a/arch/powerpc/platforms/cell/spufs/Makefile b/arch/powerpc/platforms/cell/spufs/Makefile
index b93f877..b9d5d67 100644
--- a/arch/powerpc/platforms/cell/spufs/Makefile
+++ b/arch/powerpc/platforms/cell/spufs/Makefile
@@ -13,10 +13,8 @@ SPU_CC		:= $(SPU_CROSS)gcc
 SPU_AS		:= $(SPU_CROSS)gcc
 SPU_LD		:= $(SPU_CROSS)ld
 SPU_OBJCOPY	:= $(SPU_CROSS)objcopy
-SPU_CFLAGS	:= -O2 -Wall -I$(srctree)/include \
-		   -I$(objtree)/include2 -D__KERNEL__
-SPU_AFLAGS	:= -c -D__ASSEMBLY__ -I$(srctree)/include \
-		   -I$(objtree)/include2 -D__KERNEL__
+SPU_CFLAGS	:= -O2 -Wall -I$(srctree)/include -D__KERNEL__
+SPU_AFLAGS	:= -c -D__ASSEMBLY__ -I$(srctree)/include -D__KERNEL__
 SPU_LDFLAGS	:= -N -Ttext=0x0
 
 $(obj)/switch.o: $(obj)/spu_save_dump.h $(obj)/spu_restore_dump.h
-- 
1.6.2.5

