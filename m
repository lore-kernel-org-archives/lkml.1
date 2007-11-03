Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXKCXuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXKCXuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXKCXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:49:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59235 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbXKCXto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:49:44 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 10/10] x86: enable make ARCH=x86
Date: Sun,  4 Nov 2007 00:51:20 +0100
Message-Id: <11941338812802-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1194133881756-git-send-email-sam@ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <11941338804007-git-send-email-sam@ravnborg.org> <11941338801910-git-send-email-sam@ravnborg.org> <11941338802525-git-send-email-sam@ravnborg.org> <11941338802646-git-send-email-sam@ravnborg.org> <11941338813125-git-send-email-sam@ravnborg.org> <11941338813105-git-send-email-sam@ravnborg.org> <1194133881972-git-send-email-sam@ravnborg.org> <1194133881756-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But this will break all the scripts that uses
make ARCH=i386 / make ARCH=x86_64

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile          |    5 ++---
 arch/x86/Makefile |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 188c3b6..eb22003 100644
--- a/Makefile
+++ b/Makefile
@@ -165,7 +165,8 @@ export srctree objtree VPATH TOPDIR
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
@@ -197,8 +198,6 @@ CROSS_COMPILE	?=
 UTS_MACHINE 	:= $(ARCH)
 SRCARCH 	:= $(ARCH)
 
-# for i386 and x86_64 we use SRCARCH equal to x86
-SRCARCH := $(if $(filter x86_64 i386,$(SRCARCH)),x86,$(SRCARCH))
 
 KCONFIG_CONFIG	?= .config
 
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3095973..c0a4e18 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -6,7 +6,7 @@ KBUILD_DEFCONFIG := $(ARCH)_defconfig
 # # No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
-ifeq ($(ARCH),i386)
+ifeq ($(CONFIG_X86_32),y)
         include $(srctree)/arch/x86/Makefile_32
 else
         include $(srctree)/arch/x86/Makefile_64
-- 
1.5.3.4.1157.g0e74-dirty

