Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbXJYUC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbXJYUC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXJYUCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:02:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57535 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbXJYUCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:02:10 -0400
Date: Thu, 25 Oct 2007 22:03:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 2/6] x86: move defconfig files for i386 and x86_64 to x86
Message-ID: <20071025200344.GC14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 81ee173db26217c54731bbc4c5b864fa01c6f28c Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 25 Oct 2007 20:31:19 +0200
Subject: [PATCH] x86: move defconfig files for i386 and x86_64 to x86

With some small changes to kconfig makefile we can now
locate the defconfig files for i386 and x86_64 in
the configs/ subdirectory under x86.
make ARCH=i386 defconfig and make defconfig
works as expected also after this change.
But arch maintainers shall now update a defconfig file in
the configs/ directory.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Makefile                                  |    5 ++++-
 .../{i386/defconfig => x86/configs/i386_defconfig} |    0 
 .../defconfig => x86/configs/x86_64_defconfig}     |    0 
 scripts/kconfig/Makefile                           |    6 +++---
 4 files changed, 7 insertions(+), 4 deletions(-)
 rename arch/{i386/defconfig => x86/configs/i386_defconfig} (100%)
 rename arch/{x86_64/defconfig => x86/configs/x86_64_defconfig} (100%)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 65077d7..3095973 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -1,6 +1,9 @@
 # Unified Makefile for i386 and x86_64
 
-# No need to remake these files
+# select defconfig based on actual architecture
+KBUILD_DEFCONFIG := $(ARCH)_defconfig
+
+# # No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
 ifeq ($(ARCH),i386)
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
-- 
1.5.3.4.1157.g0e74-dirty

