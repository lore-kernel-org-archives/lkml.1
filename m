Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYL0GtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYL0GtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYL0GtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:49:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35957 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYL0GtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:49:06 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86/setup.h: hide kernel stuff behind __KERNEL__ for userspace
Date: Sat, 27 Dec 2008 01:49:04 -0500
Message-Id: <1230360544-6577-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 setup.h bleeds a bunch of kernel functions/structs to userspace, so
move them behind __KERNEL__.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/x86/include/asm/setup.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index f12d372..e4c80fe 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -3,6 +3,8 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#ifdef __KERNEL__
+
 #ifndef __ASSEMBLY__
 
 /* Interrupt control for vSMPowered x86_64 systems */
@@ -49,8 +51,6 @@ extern unsigned long saved_video_mode;
 #endif
 #endif /* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
-
 #ifdef __i386__
 
 #include <linux/pfn.h>
-- 
1.6.0.6

