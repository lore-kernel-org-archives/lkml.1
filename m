Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZHQGu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZHQGu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZHQGu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:50:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47758 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbZHQGu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:50:57 -0400
Date: Mon, 17 Aug 2009 16:50:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the tip tree with the  tree
Message-Id: <20090817165051.765262cd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/trace/trace.h between commit
9ec04da7489d2c9ae01ea6e9b5fa313ccf3d35fb ("net: skb ftracer - Add actual
ftrace code to kernel (v3)") from the net tree and commit
64c12e0444fcc6b75eb49144ba46d43dbdc6bc8f ("tracing: Add individual
syscalls tracepoint id support") from the tip tree.

Just overlapping additions/removals.  I fixed it up (see below) and can
carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/trace.h
index 8a6281b,300ef78..0000000
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@@ -336,12 -317,6 +334,8 @@@ extern void __ftrace_bad_type(void)
  			  TRACE_KMEM_ALLOC);	\
  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
  			  TRACE_KMEM_FREE);	\
- 		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
- 			  TRACE_SYSCALL_ENTER);				\
- 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
- 			  TRACE_SYSCALL_EXIT);				\
 +		IF_ASSIGN(var, ent, struct trace_skb_event,		\
 +			  TRACE_SKB_SOURCE);				\
  		__ftrace_bad_type();					\
  	} while (0)
  
