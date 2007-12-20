Return-Path: <linux-kernel-owner+w=401wt.eu-S1763059AbXLTMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763059AbXLTMN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbXLTMBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761226AbXLTMA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 42/43] x86 core dump TLS
Message-Id: <20071220120023.19D5726F98E@magilla.localdomain>
Date: Thu, 20 Dec 2007 04:00:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes ELF core dumps of 32-bit processes include a new
note type NT_386_TLS (0x200) giving the contents of the TLS
slots in struct user_desc format.  This lets post mortem
examination figure out what the segment registers mean like
the debugger does with get_thread_area on a live process.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/ptrace.c |    1 +
 include/linux/elf.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index e8c2ba3..25b6578 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1314,6 +1314,7 @@ static const struct user_regset x86_32_regsets[] = {
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
 	[REGSET_TLS] = {
+		.core_note_type = NT_386_TLS,
 		.n = GDT_ENTRY_TLS_ENTRIES, .bias = GDT_ENTRY_TLS_MIN,
 		.size = sizeof(struct user_desc),
 		.align = sizeof(struct user_desc),
diff --git a/include/linux/elf.h b/include/linux/elf.h
index ba268b2..30eb6fb 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -356,6 +356,7 @@ typedef struct elf64_shdr {
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
+#define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
 
 
 /* Note header in a PT_NOTE section */
-- 
1.5.3.6

