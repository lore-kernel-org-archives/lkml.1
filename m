Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZKHLJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZKHLJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZKHLJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:09:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:42323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbZKHLJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:09:05 -0500
Date: Sun, 8 Nov 2009 11:06:41 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091105160359.5181.26225.stgit@harusame>
References: <20091105160359.5181.26225.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Remove unused thread_return label from switch_to()
Message-ID: <tip-c12a229bc5971534537a7d0e49e44f9f1f5d0336@git.kernel.org>
Git-Commit-ID: c12a229bc5971534537a7d0e49e44f9f1f5d0336
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c12a229bc5971534537a7d0e49e44f9f1f5d0336
Gitweb:     http://git.kernel.org/tip/c12a229bc5971534537a7d0e49e44f9f1f5d0336
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 5 Nov 2009 11:03:59 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 11:57:13 +0100

x86: Remove unused thread_return label from switch_to()

Remove unused thread_return label from switch_to() macro on
x86-64. Since this symbol cuts into schedule(), backtrace at the
latter half of schedule() was always shown as thread_return().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091105160359.5181.26225.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index f08f973..1a953e2 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -128,8 +128,6 @@ do {									\
 	     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \
 	     "movq %P[threadrsp](%[next]),%%rsp\n\t" /* restore RSP */	  \
 	     "call __switch_to\n\t"					  \
-	     ".globl thread_return\n"					  \
-	     "thread_return:\n\t"					  \
 	     "movq "__percpu_arg([current_task])",%%rsi\n\t"		  \
 	     __switch_canary						  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
