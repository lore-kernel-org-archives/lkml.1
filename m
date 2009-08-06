Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZHFG1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZHFG1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZHFG1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:51 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:38906 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZHFG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kjsDPxwVmD3inBWbZdJELBCg92IbmbIf46UoT/BCgS5VrbJv4LRm57+Ve2ecPrgaGL
         TM56AyshxzQ5E29EFLupvFJMeO3MVRCiKv8bxIDIckX42CUZ8J7i6AhrH0QjnZ95950r
         cyh1tBrzlPAVuRmLTqoX8Y4gvi79a9Wjm0whM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/7] tracing/function-graph-tracer: Drop the useless nmi protection
Date: Thu,  6 Aug 2009 08:27:33 +0200
Message-Id: <1249540058-5528-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function graph tracer used to have a protection against NMI
while entering a function entry tracing. But this is useless now,
this tracer is reentrant and the ring buffer supports the NMI tracing.
We can then drop this protection.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d94e1ea..8e96634 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -417,10 +417,6 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	unsigned long return_hooker = (unsigned long)
 				&return_to_handler;
 
-	/* Nmi's are currently unsupported */
-	if (unlikely(in_nmi()))
-		return;
-
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-- 
1.6.2.3

