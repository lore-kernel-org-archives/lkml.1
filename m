Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYJBXXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYJBXXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYJBXXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYJBXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:23:05 -0400
Date: Thu, 2 Oct 2008 19:23:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ftrace: move pc counter in irqstrace
Message-ID: <alpine.DEB.1.10.0810021921500.26504@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The assigning of the pc counter is in the wrong spot in the
check_critical_timing function. The pc variable is used in the
out jump.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_irqsoff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-10-02 09:07:16.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-10-02 14:16:54.000000000 -0400
@@ -142,11 +142,11 @@ check_critical_timing(struct trace_array
 
 	local_save_flags(flags);
 
+	pc = preempt_count();
+
 	if (!report_latency(delta))
 		goto out;
 
-	pc = preempt_count();
-
 	spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */

