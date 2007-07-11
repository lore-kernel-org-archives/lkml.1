Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXGKTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXGKTUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbXGKTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:15 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614AbXGKTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:11 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 05/33] Change CONFIG_X86_MINIMUM_CPU_MODEL to CONFIG_X86_MINIMUM_CPU_FAMILY
Date: Wed, 11 Jul 2007 12:18:30 -0700
Message-Id: <11841815393014-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815393975-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
Message-Id: <6ca6bf20ba1c8bef47e0042657fd9dccad3404b8.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

CONFIG_X86_MINIMUM_CPU_MODEL, so change it to
CONFIG_X86_MINIMUM_CPU_FAMILY.  Also, the default minimum should be
3, not 0.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/Kconfig.cpu         |    6 +++---
 arch/i386/kernel/verify_cpu.S |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index 5c95ceb..9cbe76c 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -344,8 +344,8 @@ config X86_CMOV
 	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
 	default y
 
-config X86_MINIMUM_CPU_MODEL
+config X86_MINIMUM_CPU_FAMILY
 	int
-	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP
-	default "0"
+	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK
+	default "3"
 
diff --git a/arch/i386/kernel/verify_cpu.S b/arch/i386/kernel/verify_cpu.S
index 3efc5c1..fff4aa6 100644
--- a/arch/i386/kernel/verify_cpu.S
+++ b/arch/i386/kernel/verify_cpu.S
@@ -9,7 +9,7 @@ verify_cpu:
 	pushl	$0			# Kill any dangerous flags
 	popfl
 
-#if CONFIG_X86_MINIMUM_CPU_MODEL >= 4
+#if CONFIG_X86_MINIMUM_CPU_FAMILY >= 4
 	pushfl
 	pop	%eax
 	orl	$(1<<18),%eax		# try setting AC
@@ -75,7 +75,7 @@ verify_cpu:
 	movl    $0x1,%eax		# Does the cpu have what it takes
 	cpuid
 
-#if CONFIG_X86_MINIMUM_CPU_MODEL > 4
+#if CONFIG_X86_MINIMUM_CPU_FAMILY > 4
 #error	add proper model checking here
 #endif
 
-- 
1.5.2.2

