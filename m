Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbXKJUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbXKJUl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 15:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXKJUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 15:41:50 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33962 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXKJUlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 15:41:49 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: Use CONFIG_64BIT to select between 32 and 64 bit in Kconfig
Date: Sat, 10 Nov 2007 21:43:27 +0100
Message-Id: <11947274093213-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11947274091127-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This change allow us to use the new syntax:
make K64BIT={n,y} to select between 32 and 64 bit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/Kconfig |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 153c26c..0d86611 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1,34 +1,24 @@
 # x86 configuration
 
 # Select 32 or 64 bit
-choice
-	bool "Select 32 or 64 bit"
-	default X86_32
+config 64BIT
+	bool "64 Bit kernel"
+	default n
+	help
+	  Say yes to build a 64 bit kernel - formerly known as x86_64
+	  Say no to build a 32 bit kernel - formerly known as i386
 
 config X86_32
-	bool "32 bit (former ARCH=i386)"
-	help
-	  This is Linux's home port.  Linux was originally native to the Intel
-	  386, and runs on all the later x86 processors including the Intel
-	  486, 586, Pentiums, and various instruction-set-compatible chips by
-	  AMD, Cyrix, and others.
+	def_bool !64BIT
 
 config X86_64
-	bool "64 bit (former ARCH=x86_64)"
-	help
-	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
-	  classical 32-bit x86 architecture. For details see
-	  <http://www.x86-64.org/>.
-endchoice
+	def_bool 64BIT
 
 ### Arch settings
 config X86
 	bool
 	default y
 
-config 64BIT
-	def_bool X86_64
-
 config GENERIC_TIME
 	bool
 	default y
-- 
1.5.3.4.1157.g0e74-dirty

