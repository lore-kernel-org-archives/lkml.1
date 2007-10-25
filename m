Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXJYUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXJYUDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbXJYUDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:03:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45532 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbXJYUDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:03:38 -0400
Date: Thu, 25 Oct 2007 22:05:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 4/6] kconfig: small code refactoring in kconfig Makefile
Message-ID: <20071025200513.GE14501@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7cadfc607d91f536996a46c186711c82378e75ec Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 25 Oct 2007 20:42:18 +0200
Subject: [PATCH] kconfig: small code refactoring in kconfig Makefile

Do not hardcode the arch/$(ARCH)/Kconfig name all over

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/Makefile |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fbf39cc..3c9db07 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -4,23 +4,25 @@
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config
 
+Kconfig := arch/$(ARCH)/Kconfig
+
 xconfig: $(obj)/qconf
-	$< arch/$(ARCH)/Kconfig
+	$< $(Kconfig)
 
 gconfig: $(obj)/gconf
-	$< arch/$(ARCH)/Kconfig
+	$< $(Kconfig)
 
 menuconfig: $(obj)/mconf
-	$< arch/$(ARCH)/Kconfig
+	$< $(Kconfig)
 
 config: $(obj)/conf
-	$< arch/$(ARCH)/Kconfig
+	$< $(Kconfig)
 
 oldconfig: $(obj)/conf
-	$< -o arch/$(ARCH)/Kconfig
+	$< -o $(Kconfig)
 
 silentoldconfig: $(obj)/conf
-	$< -s arch/$(ARCH)/Kconfig
+	$< -s $(Kconfig)
 
 # Create new linux.po file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
@@ -45,27 +47,27 @@ update-po-config: $(obj)/kxgettext
 PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig
 
 randconfig: $(obj)/conf
-	$< -r arch/$(ARCH)/Kconfig
+	$< -r $(Kconfig)
 
 allyesconfig: $(obj)/conf
-	$< -y arch/$(ARCH)/Kconfig
+	$< -y $(Kconfig)
 
 allnoconfig: $(obj)/conf
-	$< -n arch/$(ARCH)/Kconfig
+	$< -n $(Kconfig)
 
 allmodconfig: $(obj)/conf
-	$< -m arch/$(ARCH)/Kconfig
+	$< -m $(Kconfig)
 
 defconfig: $(obj)/conf
 ifeq ($(KBUILD_DEFCONFIG),)
-	$< -d arch/$(ARCH)/Kconfig
+	$< -d $(Kconfig)
 else
 	@echo "*** Default configuration is based on '$(KBUILD_DEFCONFIG)'"
-	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) arch/$(ARCH)/Kconfig
+	$(Q)$< -D arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG) $(Kconfig)
 endif
 
 %_defconfig: $(obj)/conf
-	$(Q)$< -D arch/$(SRCARCH)/configs/$@ arch/$(ARCH)/Kconfig
+	$(Q)$< -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
 
 # Help text used by make help
 help:
-- 
1.5.3.4.1157.g0e74-dirty

