Return-Path: <linux-kernel-owner+w=401wt.eu-S1761014AbZCSVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761014AbZCSVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbZCSVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:09:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56792 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760652AbZCSVJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:09:28 -0400
Message-ID: <49C2B4B8.1020507@redhat.com>
Date: Thu, 19 Mar 2009 17:10:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, ia64 <linux-ia64@vger.kernel.org>
Subject: [RFC][PATCH -tip 3/9] ia64: add kernel_trap_sp()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kernel_trap_sp() on ia64, based on systemtap's runtime/regs.h.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/ptrace.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/ptrace.h b/arch/ia64/include/asm/ptrace.h
index 14055c6..3a7dfcb 100644
--- a/arch/ia64/include/asm/ptrace.h
+++ b/arch/ia64/include/asm/ptrace.h
@@ -246,6 +246,12 @@ static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 	return regs->ar_bspstore;
 }

+static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
+{
+	/* interrupted task's memory stack pointer is r12 */
+	return regs->r12;
+}
+
 #define regs_return_value(regs) ((regs)->r8)

 /* Conserve space in histogram by encoding slot bits in address
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


