Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXJXV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXJXV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXJXV3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:29:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37136 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbXJXV3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:29:19 -0400
Date: Wed, 24 Oct 2007 23:30:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-ID: <20071024213052.GA5469@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org> <20071024121218.GA23548@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024121218.GA23548@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

This is first step in getting rid of the two directories.
I had to do some very minor modifications in common files
to let it work out - but nothing really hackish.

If you & Thomas + hpa are OK with the changes they can be
pulled from:

	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git

As this is mostly renames I have attached a git -M diff only.

The remaining stuff is Kconfig files.

Before looking into these I am hoping someone could
step in and make the two Kconfig.debug
files 100% equal - because then I can fix the kconfig
stuff and finally kill the two directories.

	Sam


commit 4aaac9bda3be500750347129ee13d63e80bf4b9f
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Wed Oct 24 23:00:06 2007 +0200

    x86: move defconfig files for i386 and x86_64 to x86
    
    With some small changes to kconfig makefile we can now
    locate the defconfig files for i386 and x86_64 in
    the configs/ subdirectory under x86.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

commit f745ab20e4697829100edfe29035d491f7efdc42
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Wed Oct 24 22:44:11 2007 +0200

    x86: move i386 and x86_64 Makefiles to arch/x86
    
    Moving the ARCH specific MAkefiles for i386 and x86_64
    required a litle bit tweaking in the top-lvel Makefile.
    But this is one of the final steps to get rid of the
    x86_64 and i386 directories.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>


git diff -M --stat:

 Makefile                                           |    7 +++++--
 arch/{i386/Makefile => x86/Makefile_32}            |    4 ++--
 arch/{i386/Makefile.cpu => x86/Makefile_32.cpu}    |    0 
 arch/{x86_64/Makefile => x86/Makefile_64}          |    2 +-
 .../{i386/defconfig => x86/configs/i386_defconfig} |    0 
 .../defconfig => x86/configs/x86_64_defconfig}     |    0 
 scripts/kconfig/Makefile                           |    6 +++---
 7 files changed, 11 insertions(+), 8 deletions(-)

git diff -M:

diff --git a/Makefile b/Makefile
index 2a47290..8816060 100644
--- a/Makefile
+++ b/Makefile
@@ -196,6 +196,9 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
+# for i386 and x86_64 we use SRCARCH equal to x86
+SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))
+
 KCONFIG_CONFIG	?= .config
 
 # SHELL used by kbuild
@@ -418,7 +421,7 @@ ifeq ($(config-targets),1)
 # Read arch specific Makefile to set KBUILD_DEFCONFIG as needed.
 # KBUILD_DEFCONFIG may point out an alternative default configuration
 # used for 'make defconfig'
-include $(srctree)/arch/$(ARCH)/Makefile
+include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG
 
 config %config: scripts_basic outputmakefile FORCE
@@ -497,7 +500,7 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
-include $(srctree)/arch/$(ARCH)/Makefile
+include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/arch/i386/Makefile b/arch/x86/Makefile_32
similarity index 98%
rename from arch/i386/Makefile
rename to arch/x86/Makefile_32
index f5b9a37..c0b81d0 100644
--- a/arch/i386/Makefile
+++ b/arch/x86/Makefile_32
@@ -1,5 +1,5 @@
 #
-# i386/Makefile
+# i386 Makefile
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
@@ -46,7 +46,7 @@ KBUILD_CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
 KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)
 
 # CPU-specific tuning. Anything which can be shared with UML should go here.
-include $(srctree)/arch/i386/Makefile.cpu
+include $(srctree)/arch/x86/Makefile_32.cpu
 
 # temporary until string.h is fixed
 cflags-y += -ffreestanding
diff --git a/arch/i386/Makefile.cpu b/arch/x86/Makefile_32.cpu
similarity index 100%
rename from arch/i386/Makefile.cpu
rename to arch/x86/Makefile_32.cpu
diff --git a/arch/x86_64/Makefile b/arch/x86/Makefile_64
similarity index 99%
rename from arch/x86_64/Makefile
rename to arch/x86/Makefile_64
index 20eb69b..52adc8c 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86/Makefile_64
@@ -1,5 +1,5 @@
 #
-# x86_64/Makefile
+# x86_64 Makefile
 #
 # This file is included by the global makefile so that you can add your own
 # architecture-specific flags and dependencies. Remember to do have actions
diff --git a/arch/i386/defconfig b/arch/x86/configs/i386_defconfig
similarity index 100%
rename from arch/i386/defconfig
rename to arch/x86/configs/i386_defconfig
diff --git a/arch/x86_64/defconfig b/arch/x86/configs/x86_64_defconfig
similarity index 100%
rename from arch/x86_64/defconfig
rename to arch/x86/configs/x86_64_defconfig
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 83c5e76..fbf39cc 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -60,12 +60,12 @@ defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
 	$< -d arch/$(ARCH)/Kconfig
 else
-	@echo *** Default configuration is based on '$(KBUILD_DEFCONFIG)'
-	$(Q)$< -D arch/$(ARCH)/configs/$(KBUILD_DEFCONFIG) arch/$(ARCH)/Kconfig
+	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
+	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) arch/$(ARCH)/Kconfig
 endif
 
 %_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(ARCH)/configs/$@ arch/$(ARCH)/Kconfig
+	$(Q)$< -D arch/$(SRCARCH)/configs/$@ arch/$(ARCH)/Kconfig
 
 # Help text used by make help
 help:
