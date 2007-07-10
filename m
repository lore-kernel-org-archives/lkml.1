Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXGJDID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXGJDID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760927AbXGJDHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:07:53 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbXGJDHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:07:52 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 05/33] Change CONFIG_X86_MINIMUM_CPU_MODEL to CONFIG_X86_MINIMUM_CPU_FAMILY
Date: Mon,  9 Jul 2007 19:51:44 -0700
Message-Id: <11840364593068-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840363531039-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
Message-Id: <8376b111bbf6bf6c8c884fabcb9c1844950737b0.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

