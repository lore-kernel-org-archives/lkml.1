Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZIKPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZIKPRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZIKPR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:17:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33577 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbZIKPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:17:16 -0400
Message-Id: <20090911151718.820062651@goodmis.org>
References: <20090911151544.006804282@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 11:15:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 1/2] x86/tracing: comment need for atomic nop
Content-Disposition: inline; filename=0001-x86-tracing-comment-need-for-atomic-nop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The dynamic function tracer relys on the macro P6_NOP5 always being
an atomic NOP. If for some reason it is changed to be two operations
(like a nop2 nop3) it can faults within the kernel when the function
tracer modifies the code.

This patch adds a comment to note that the P6_NOPs are expected to
be atomic. This will hopefully prevent anyone from changing that.

Reported-by: Mathieu Desnoyer <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/nops.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index ad2668e..6d8723a 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -65,6 +65,8 @@
    6: osp nopl 0x00(%eax,%eax,1)
    7: nopl 0x00000000(%eax)
    8: nopl 0x00000000(%eax,%eax,1)
+   Note: All the above are assumed to be a single instruction.
+	There is kernel code that depends on this.
 */
 #define P6_NOP1	GENERIC_NOP1
 #define P6_NOP2	".byte 0x66,0x90\n"
-- 
1.6.3.3

-- 
