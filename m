Return-Path: <linux-kernel-owner+w=401wt.eu-S1762516AbYHHV4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762516AbYHHV4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761951AbYHHVxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:51 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:29776 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761941AbYHHVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WsqestUYLHmb9HKcSRTHDGaXslyO5Dfiq5AGnkiEoyQSKoF+AXXUxmL7vMOOTYW3OS
         KzbiQdQs+K6iVb9MHjSpX1Pn5r5NWYv1Eidd3Uc1gxrgVb22vTuRHE8qBwaT6VV8q2nO
         j8EYUHwQlhbdrpmSZE6YGB18jTHpzW+WfRcKA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 07/42] x86: enable dyn_array support
Date: Fri,  8 Aug 2008 14:52:13 -0700
Message-Id: <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/Kconfig                     |    2 ++
 arch/x86/Kconfig                 |    1 +
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    3 +++
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 0267bab..c1f9feb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -103,3 +103,5 @@ config HAVE_CLK
 	  The <linux/clk.h> calls support software clock gating and
 	  thus are a key power management tool on many systems.
 
+config HAVE_DYN_ARRAY
+	def_bool n
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bd30e8b..d30b101 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -33,6 +33,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_DYN_ARRAY
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 248a575..20b835a 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -145,6 +145,7 @@ SECTIONS
 	*(.x86cpuvendor.init)
 	__x86cpuvendor_end = .;
   }
+  DYN_ARRAY_INIT(8)
   SECURITY_INIT
   . = ALIGN(4);
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 63e5c1a..5b9cc10 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -174,6 +174,9 @@ SECTIONS
 	*(.x86cpuvendor.init)
   }
   __x86cpuvendor_end = .;
+
+  DYN_ARRAY_INIT(8)
+
   SECURITY_INIT
 
   . = ALIGN(8);
-- 
1.5.4.5

