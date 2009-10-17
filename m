Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZJQJ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZJQJ7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 05:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZJQJ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 05:59:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:36261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZJQJ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 05:59:52 -0400
Date: Sat, 17 Oct 2009 09:59:07 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86/ptrace: Fix regs_get_argument_nth() to add correct offset
Message-ID: <tip-ad5cafcdb09c57008c990edd309c0a563b09f238@git.kernel.org>
Git-Commit-ID: ad5cafcdb09c57008c990edd309c0a563b09f238
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 09:59:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad5cafcdb09c57008c990edd309c0a563b09f238
Gitweb:     http://git.kernel.org/tip/ad5cafcdb09c57008c990edd309c0a563b09f238
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 10 Sep 2009 19:53:06 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 11 Sep 2009 04:14:24 +0200

x86/ptrace: Fix regs_get_argument_nth() to add correct offset

Fix regs_get_argument_nth() to add correct offset bytes. Because
offset_of() returns offset in byte, the offset should be added
to char * instead of unsigned long *.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090910235306.22412.31613.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index a33a17d..caffb68 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -150,7 +150,7 @@ static const int arg_offs_table[] = {
 unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n)
 {
 	if (n < ARRAY_SIZE(arg_offs_table))
-		return *((unsigned long *)regs + arg_offs_table[n]);
+		return *(unsigned long *)((char *)regs + arg_offs_table[n]);
 	else {
 		/*
 		 * The typical case: arg n is on the stack.
