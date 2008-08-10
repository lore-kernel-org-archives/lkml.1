Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYHJHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYHJHkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYHJHhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:37:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYHJHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ljXs7Rv+wsfap6GI8ovCtpFmukL/J3HYbPY5IU9s3srGJNu75u+g2xikLt/eQ2utPf
         gKA0dnD9SDCJU4n/igsSYB1hGAB+Qr1wJZaZq98+ipZYWlINiZ1NB1NLvBGJCk8KpnIn
         eEa+3wsy964+zE7XZMeAtorZYeMrThiKd3hOo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 08/43] x86: enable dyn_array support
Date: Sun, 10 Aug 2008 00:35:57 -0700
Message-Id: <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
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

