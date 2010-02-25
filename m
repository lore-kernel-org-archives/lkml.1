Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0BYT3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:29:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:33774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882Ab0BYT3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:29:41 -0500
Date: Thu, 25 Feb 2010 19:27:58 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, mathieu.desnoyers@efficios.com, andersk@ksplice.com,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, compudj@krystal.dyndns.org, jbaron@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, mathieu.desnoyers@efficios.com,
       andersk@ksplice.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, tglx@linutronix.de, jbaron@redhat.com,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133349.6725.99302.stgit@localhost6.localdomain6>
References: <20100225133349.6725.99302.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE
Message-ID: <tip-d498f763950703c724c650db1d34a1c8679f9ca8@git.kernel.org>
Git-Commit-ID: d498f763950703c724c650db1d34a1c8679f9ca8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:28:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d498f763950703c724c650db1d34a1c8679f9ca8
Gitweb:     http://git.kernel.org/tip/d498f763950703c724c650db1d34a1c8679f9ca8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:33:49 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:24 +0100

kprobes/x86: Cleanup RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE

Change RELATIVEJUMP_INSTRUCTION macro to RELATIVEJUMP_OPCODE
since it represents just the opcode byte.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133349.6725.99302.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 5de9f4a..15177cd 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -115,7 +115,7 @@ static void __kprobes set_jmp_op(void *from, void *to)
 	} __attribute__((packed)) * jop;
 	jop = (struct __arch_jmp_op *)from;
 	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
-	jop->op = RELATIVEJUMP_INSTRUCTION;
+	jop->op = RELATIVEJUMP_OPCODE;
 }
 
 /*
