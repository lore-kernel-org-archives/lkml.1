Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYKZWFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYKZWFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYKZWE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:04:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYKZWEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:04:25 -0500
Message-Id: <20081126220423.271975594@goodmis.org>
References: <20081126215821.263324391@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 16:58:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] powerpc: ftrace, added missing icache flush
Content-Disposition: inline; filename=0003-powerpc-ftrace-added-missing-icache-flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to PowerPC code modification

After modifying code it is essential to flush the icache. This patch
adds the missing flush.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ea454a0..a4640e4 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -271,6 +271,9 @@ __ftrace_make_nop(struct module *mod,
 	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
+
+	flush_icache_range(ip, ip + 8);
+
 	return 0;
 }
 
@@ -342,6 +345,8 @@ __ftrace_make_nop(struct module *mod,
 	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
+	flush_icache_range(ip, ip + 8);
+
 	return 0;
 }
 #endif /* PPC64 */
@@ -438,6 +443,8 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	if (probe_kernel_write((void *)ip, op, MCOUNT_INSN_SIZE * 2))
 		return -EPERM;
 
+	flush_icache_range(ip, ip + 8);
+
 	return 0;
 }
 #else
@@ -481,6 +488,8 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	if (probe_kernel_write((void *)ip, &op, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
+	flush_icache_range(ip, ip + 8);
+
 	return 0;
 }
 #endif /* CONFIG_PPC64 */
-- 
1.5.6.5

-- 
