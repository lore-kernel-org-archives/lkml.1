Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYGQHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYGQHfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYGQHb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:31:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbYGQHb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:31:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 20/23] tracehook: CONFIG_HAVE_ARCH_TRACEHOOK
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
X-Shopping-List: (1) Cretaceous Prostitutes
   (2) Aquatic harmonizers
   (3) Condo-conscious geese
   (4) Reminiscent amorphous L'eggs
   (5) Prosaic minion cheeses
Message-Id: <20080717073122.750E71541A5@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:31:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the generic HAVE_ARCH_TRACEHOOK kconfig item.
Each arch should add to some Kconfig file:
	select HAVE_ARCH_TRACEHOOK
if the arch code uses all the latest hooks to enable newfangled
tracing and debugging code.  The comment in arch/Kconfig lists
all the prerequisite arch support.  When all these are available,
setting HAVE_ARCH_TRACEHOOK will allow enabling any new features
that depend on the modern arch interfaces.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/Kconfig |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index ad89a33..4641edf 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -37,6 +37,24 @@ config HAVE_KPROBES
 config HAVE_KRETPROBES
 	def_bool n
 
+#
+# An arch should select this if it provides all these things:
+#
+#	task_pt_regs()		in asm/processor.h or asm/ptrace.h
+#	arch_has_single_step()	if there is hardware single-step support
+#	arch_has_block_step()	if there is hardware block-step support
+#	arch_ptrace()		and not #define __ARCH_SYS_PTRACE
+#	compat_arch_ptrace()	and #define __ARCH_WANT_COMPAT_SYS_PTRACE
+#	asm/syscall.h		supplying asm-generic/syscall.h interface
+#	linux/regset.h		user_regset interfaces
+#	CORE_DUMP_USE_REGSET	#define'd in linux/elf.h
+#	TIF_SYSCALL_TRACE	calls tracehook_report_syscall_{entry,exit}
+#	TIF_NOTIFY_RESUME	calls tracehook_notify_resume()
+#	signal delivery		calls tracehook_signal_handler()
+#
+config HAVE_ARCH_TRACEHOOK
+	def_bool n
+
 config HAVE_DMA_ATTRS
 	def_bool n
 
