Return-Path: <linux-kernel-owner+w=401wt.eu-S933628AbZINXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbZINXn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933600AbZINXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:43:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933509AbZINXnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:43:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC PATCH -tip v4 1/9] kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION
	to RELATIVEJUMP_OPCODE
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>
Date: Mon, 14 Sep 2009 19:44:59 -0400
Message-ID: <20090914234459.25174.65809.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090914234448.25174.70702.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914234448.25174.70702.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change RELATIVEJUMP_INSTRUCTION macro to RELATIVEJUMP_OPCODE since it
represents just the opcode byte.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
---

 arch/x86/include/asm/kprobes.h |    2 +-
 arch/x86/kernel/kprobes.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 4fe681d..eaec8ea 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -32,7 +32,7 @@ struct kprobe;
 
 typedef u8 kprobe_opcode_t;
 #define BREAKPOINT_INSTRUCTION	0xcc
-#define RELATIVEJUMP_INSTRUCTION 0xe9
+#define RELATIVEJUMP_OPCODE 0xe9
 #define MAX_INSN_SIZE 16
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c5f1f11..e36ef97 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -126,7 +126,7 @@ static void __kprobes set_jmp_op(void *from, void *to)
 	} __attribute__((packed)) * jop;
 	jop = (struct __arch_jmp_op *)from;
 	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_INSTRUCTION;
+	jop->op = RELATIVEJUMP_OPCODE;
 }
 
 /*


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
