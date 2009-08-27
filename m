Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZH0Cfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZH0Cfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbZH0Cch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:37 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:54351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbZH0Ccd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=AWVs9hMz05wfOwau2KkuN4AawPxbV0alBgOybPCFrOsEEFaIEKvB0Cztv0Tq7c7LTW
         lGGZJVH3okUkKlP9HB7GeDplqXB4Jkt/fz9Sjlf/xYP4sSNTqyj7edgWcYgE7gVx7Rxw
         Y2gQKIIqs5XA/jgdP/LFNevOmDr2GFeXfZHtU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-arch@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/18] x86: Add pt_regs register and stack access APIs
Date: Thu, 27 Aug 2009 04:32:04 +0200
Message-Id: <1251340337-5640-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add following APIs for accessing registers and stack entries from
pt_regs.
These APIs are required by kprobes-based event tracer on ftrace.
Some other debugging tools might be able to use it too.

- regs_query_register_offset(const char *name)
   Query the offset of "name" register.

- regs_query_register_name(unsigned int offset)
   Query the name of register by its offset.

- regs_get_register(struct pt_regs *regs, unsigned int offset)
   Get the value of a register by its offset.

- regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr)
   Check the address is in the kernel stack.

- regs_get_kernel_stack_nth(struct pt_regs *reg, unsigned int nth)
   Get Nth entry of the kernel stack. (N >= 0)

- regs_get_argument_nth(struct pt_regs *reg, unsigned int nth)
   Get Nth argument at function call. (N >= 0)

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-arch@vger.kernel.org
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
LKML-Reference: <20090813203444.31965.26374.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/ptrace.h |   62 ++++++++++++++++++++++
 arch/x86/kernel/ptrace.c      |  112 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 0f0d908..a3d49dd 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -7,6 +7,7 @@
 
 #ifdef __KERNEL__
 #include <asm/segment.h>
+#include <asm/page_types.h>
 #endif
 
 #ifndef __ASSEMBLY__
@@ -216,6 +217,67 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->sp;
 }
 
+/* Query offset/name of register from its name/offset */
+extern int regs_query_register_offset(const char *name);
+extern const char *regs_query_register_name(unsigned int offset);
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, ss))
+
+/**
+ * regs_get_register() - get register value from its offset
+ * @regs:	pt_regs from which register value is gotten.
+ * @offset:	offset number of the register.
+ *
+ * regs_get_register returns the value of a register whose offset from @regs
+ * is @offset. The @offset is the offset of the register in struct pt_regs.
+ * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
+ */
+static inline unsigned long regs_get_register(struct pt_regs *regs,
+					      unsigned int offset)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return 0;
+	return *(unsigned long *)((unsigned long)regs + offset);
+}
+
+/**
+ * regs_within_kernel_stack() - check the address in the stack
+ * @regs:	pt_regs which contains kernel stack pointer.
+ * @addr:	address which is checked.
+ *
+ * regs_within_kenel_stack() checks @addr is within the kernel stack page(s).
+ * If @addr is within the kernel stack, it returns true. If not, returns false.
+ */
+static inline int regs_within_kernel_stack(struct pt_regs *regs,
+					   unsigned long addr)
+{
+	return ((addr & ~(THREAD_SIZE - 1))  ==
+		(kernel_stack_pointer(regs) & ~(THREAD_SIZE - 1)));
+}
+
+/**
+ * regs_get_kernel_stack_nth() - get Nth entry of the stack
+ * @regs:	pt_regs which contains kernel stack pointer.
+ * @n:		stack entry number.
+ *
+ * regs_get_kernel_stack_nth() returns @n th entry of the kernel stack which
+ * is specifined by @regs. If the @n th entry is NOT in the kernel stack,
+ * this returns 0.
+ */
+static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
+						      unsigned int n)
+{
+	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
+	addr += n;
+	if (regs_within_kernel_stack(regs, (unsigned long)addr))
+		return *addr;
+	else
+		return 0;
+}
+
+/* Get Nth argument at function call */
+extern unsigned long regs_get_argument_nth(struct pt_regs *regs,
+					   unsigned int n);
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8d7d5c9..a33a17d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -49,6 +49,118 @@ enum x86_regset {
 	REGSET_IOPERM32,
 };
 
+struct pt_regs_offset {
+	const char *name;
+	int offset;
+};
+
+#define REG_OFFSET_NAME(r) {.name = #r, .offset = offsetof(struct pt_regs, r)}
+#define REG_OFFSET_END {.name = NULL, .offset = 0}
+
+static const struct pt_regs_offset regoffset_table[] = {
+#ifdef CONFIG_X86_64
+	REG_OFFSET_NAME(r15),
+	REG_OFFSET_NAME(r14),
+	REG_OFFSET_NAME(r13),
+	REG_OFFSET_NAME(r12),
+	REG_OFFSET_NAME(r11),
+	REG_OFFSET_NAME(r10),
+	REG_OFFSET_NAME(r9),
+	REG_OFFSET_NAME(r8),
+#endif
+	REG_OFFSET_NAME(bx),
+	REG_OFFSET_NAME(cx),
+	REG_OFFSET_NAME(dx),
+	REG_OFFSET_NAME(si),
+	REG_OFFSET_NAME(di),
+	REG_OFFSET_NAME(bp),
+	REG_OFFSET_NAME(ax),
+#ifdef CONFIG_X86_32
+	REG_OFFSET_NAME(ds),
+	REG_OFFSET_NAME(es),
+	REG_OFFSET_NAME(fs),
+	REG_OFFSET_NAME(gs),
+#endif
+	REG_OFFSET_NAME(orig_ax),
+	REG_OFFSET_NAME(ip),
+	REG_OFFSET_NAME(cs),
+	REG_OFFSET_NAME(flags),
+	REG_OFFSET_NAME(sp),
+	REG_OFFSET_NAME(ss),
+	REG_OFFSET_END,
+};
+
+/**
+ * regs_query_register_offset() - query register offset from its name
+ * @name:	the name of a register
+ *
+ * regs_query_register_offset() returns the offset of a register in struct
+ * pt_regs from its name. If the name is invalid, this returns -EINVAL;
+ */
+int regs_query_register_offset(const char *name)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (!strcmp(roff->name, name))
+			return roff->offset;
+	return -EINVAL;
+}
+
+/**
+ * regs_query_register_name() - query register name from its offset
+ * @offset:	the offset of a register in struct pt_regs.
+ *
+ * regs_query_register_name() returns the name of a register from its
+ * offset in struct pt_regs. If the @offset is invalid, this returns NULL;
+ */
+const char *regs_query_register_name(unsigned int offset)
+{
+	const struct pt_regs_offset *roff;
+	for (roff = regoffset_table; roff->name != NULL; roff++)
+		if (roff->offset == offset)
+			return roff->name;
+	return NULL;
+}
+
+static const int arg_offs_table[] = {
+#ifdef CONFIG_X86_32
+	[0] = offsetof(struct pt_regs, ax),
+	[1] = offsetof(struct pt_regs, dx),
+	[2] = offsetof(struct pt_regs, cx)
+#else /* CONFIG_X86_64 */
+	[0] = offsetof(struct pt_regs, di),
+	[1] = offsetof(struct pt_regs, si),
+	[2] = offsetof(struct pt_regs, dx),
+	[3] = offsetof(struct pt_regs, cx),
+	[4] = offsetof(struct pt_regs, r8),
+	[5] = offsetof(struct pt_regs, r9)
+#endif
+};
+
+/**
+ * regs_get_argument_nth() - get Nth argument at function call
+ * @regs:	pt_regs which contains registers at function entry.
+ * @n:		argument number.
+ *
+ * regs_get_argument_nth() returns @n th argument of a function call.
+ * Since usually the kernel stack will be changed right after function entry,
+ * you must use this at function entry. If the @n th entry is NOT in the
+ * kernel stack or pt_regs, this returns 0.
+ */
+unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
+{
+	if (n < ARRAY_SIZE(arg_offs_table))
+		return *((unsigned long *)regs + arg_offs_table[n]);
+	else {
+		/*
+		 * The typical case: arg n is on the stack.
+		 * (Note: stack[0] = return address, so skip it)
+		 */
+		n -= ARRAY_SIZE(arg_offs_table);
+		return regs_get_kernel_stack_nth(regs, 1 + n);
+	}
+}
+
 /*
  * does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
-- 
1.6.2.3

