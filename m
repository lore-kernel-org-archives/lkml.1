Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZG2RNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZG2RNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZG2RNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:13:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:31454 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbZG2RNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H/mzyVeC7Pf+IhaGjHYyCQb0coKoGBrX80yGjAaivOjmZsFtcFEtodleLOX9G4fRrS
         DPEHxZFwyR9wOiZ3aT36FVjqc/Cb0VyoQTf1xaPDfUks+m1wQXcGOoCBF1E0lsJZaQV0
         aRp3xlpg06fIaH4w+pANwvq+k+H1uManQwae0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/6] tracing/function-graph-tracer: Drop the useless nmi protection
Date: Wed, 29 Jul 2009 19:13:25 +0200
Message-Id: <1248887609-5147-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
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

