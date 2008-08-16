Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYHPFxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYHPFxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 01:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYHPFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 01:53:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33695 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYHPFxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 01:53:08 -0400
From: "Andi Kleen" <andi@firstfloor.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Move sysctl check into debugging section and don't make it default y
Date: Sat, 16 Aug 2008 07:53:05 +0200
Message-Id: <1218865985-23403-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I noticed that sysctl_check.o was the largest object file in
a allnoconfig build in kernel/*.

  36243       0       0   36243    8d93 kernel/sysctl_check.o

This is because it was default y and && EMBEDDED. But I don't
really see a need for a non kernel developer to have their
sysctls checked all the time.

So move the Kconfig into the kernel debugging section and
also drop the default y and the EMBEDDED check.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 init/Kconfig      |   11 -----------
 lib/Kconfig.debug |    8 ++++++++
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b678803..c11da38 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -558,17 +558,6 @@ config SYSCTL_SYSCALL
 
 	  If unsure say Y here.
 
-config SYSCTL_SYSCALL_CHECK
-	bool "Sysctl checks" if EMBEDDED
-	depends on SYSCTL_SYSCALL
-	default y
-	---help---
-	  sys_sysctl uses binary paths that have been found challenging
-	  to properly maintain and use. This enables checks that help
-	  you to keep things correct.
-
-	  If unsure say Y here.
-
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
 	 default y
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 800ac84..8b5a7d3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -693,6 +693,14 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config SYSCTL_SYSCALL_CHECK
+	bool "Sysctl checks"
+	depends on SYSCTL_SYSCALL
+	---help---
+	  sys_sysctl uses binary paths that have been found challenging
+	  to properly maintain and use. This enables checks that help
+	  you to keep things correct.
+
 source kernel/trace/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
-- 
1.5.6

