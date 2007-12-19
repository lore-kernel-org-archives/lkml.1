Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbXLSV50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbXLSV50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXLSV5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:57:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXLSV5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:57:18 -0500
Message-ID: <47699194.3060809@redhat.com>
Date: Wed, 19 Dec 2007 16:48:04 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
CC: Roland McGrath <roland@redhat.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 1/3] x86: fix kprobe_handler reenable preemption
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a preemption bug in kprobe_handler(). It has to call preempt_enable()
before returning.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/kernel/kprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/arch/x86/kernel/kprobes.c
===================================================================
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -467,7 +467,8 @@ static int __kprobes kprobe_handler(stru
 				arch_disarm_kprobe(p);
 				regs->ip = (unsigned long)p->addr;
 				reset_current_kprobe();
-				return 1;
+				ret = 1;
+				goto no_kprobe;
 #endif
 			}
 			/* We have reentered the kprobe_handler(), since
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

