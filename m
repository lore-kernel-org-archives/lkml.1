Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZA2AQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZA2AQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbZA1XqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbZA1XqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:17 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 078/114] x86, bigsmp: consolidate code
Date: Wed, 28 Jan 2009 23:42:24 +0000
Message-Id: <1233186180-29883-79-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all code to arch/x86/kernel/bigsmp_32.c.

With this it ceases to rely on any build-time subarch features.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile                           |    1 +
 .../{mach-generic/bigsmp.c => kernel/bigsmp_32.c}  |    0
 arch/x86/mach-generic/Makefile                     |    1 -
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/x86/{mach-generic/bigsmp.c => kernel/bigsmp_32.c} (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 37fa30b..ad6df80 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
+obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/kernel/bigsmp_32.c
similarity index 100%
rename from arch/x86/mach-generic/bigsmp.c
rename to arch/x86/kernel/bigsmp_32.c
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 4ede08d..05e4a7c 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -5,4 +5,3 @@
 EXTRA_CFLAGS			:= -Iarch/x86/kernel
 
 obj-y				:= probe.o default.o
-obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
-- 
1.6.0.2

