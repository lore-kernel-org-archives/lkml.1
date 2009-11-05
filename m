Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZKEQEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZKEQEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbZKEQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:04:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbZKEQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:04:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] [Cleanup] x86/x86-64: Remove unused thread_return label
	from switch_to()
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 05 Nov 2009 11:03:59 -0500
Message-ID: <20091105160359.5181.26225.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused thread_return label from switch_to() macro on x86-64.
Since this symbol cuts into schedule(), backtrace at the latter
half of schedule() was always shown as thread_return().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
