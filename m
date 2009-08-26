Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZHZGMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZHZGMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZHZGMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:12:35 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:41934 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbZHZGMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:12:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ItKbTR0czvc/fwbiOKrpmNJK5LZflEvJWdU3zXCOubfsd0zuCt6ze4bgm4zdPCQG2Z
         U966aY5fTyv5ZwqOF3Fu7OEoPLYzXiU+n5sWh6n662EqmZOg61RASEIk/NliAOGleVXG
         B2gDPSx5BbCDNPc4SZ8tXfkYfSo8Pcl1ythJE=
Subject: Subject: [PATCH 02/33] score: Makefile and boot/Makefile for score
From: "Chen Liqin (Gmail)" <liqin.gnu@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:02:14 +0800
Message-Id: <1251266534.16454.13.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 382e060e1a5164a276241bd99d6f9017b6723244 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:56 +0800
Subject: [PATCH 02/33] score: Makefile and boot/Makefile for score


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Makefile      |   43 +++++++++++++++++++++++++++++++++++++++++++
 arch/score/boot/Makefile |   15 +++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/Makefile
 create mode 100644 arch/score/boot/Makefile

diff --git a/arch/score/Makefile b/arch/score/Makefile
new file mode 100644
index 0000000..40a5b19
--- /dev/null
+++ b/arch/score/Makefile
@@ -0,0 +1,43 @@
+#
+# arch/score/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+KBUILD_DEFCONFIG := spct6600_defconfig
+CROSS_COMPILE := score-linux-
+
+#
+# CPU-dependent compiler/assembler options for optimization.
+#
+cflags-y += -g -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
+	-D__linux__ -ffunction-sections -ffreestanding
+
+#
+# Board-dependent options and extra files
+#
+KBUILD_AFLAGS += $(cflags-y)
+KBUILD_CFLAGS += $(cflags-y)
+MODFLAGS += -mlong-calls
+LDFLAGS += --oformat elf32-littlescore
+LDFLAGS_vmlinux	+= -G0 -static -nostdlib
+
+head-y := arch/score/kernel/head.o
+libs-y += arch/score/lib/
+core-y += arch/score/kernel/ arch/score/mm/
+
+boot := arch/score/boot
+
+vmlinux.bin: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+archclean:
+	@$(MAKE) $(clean)=$(boot)
+
+define archhelp
+	echo '  vmlinux.bin          - Raw binary boot image'
+	echo
+	echo '  These will be default as apropriate for a configured platform.'
+endef
diff --git a/arch/score/boot/Makefile b/arch/score/boot/Makefile
new file mode 100644
index 0000000..0c5fbd0
--- /dev/null
+++ b/arch/score/boot/Makefile
@@ -0,0 +1,15 @@
+#
+# arch/score/boot/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+targets	:= vmlinux.bin
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
+
+clean-files += vmlinux.bin
-- 
1.6.2



