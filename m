Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYEVSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYEVSG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYEVSGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:06:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbYEVSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:06:46 -0400
Date: Thu, 22 May 2008 14:06:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace: fix check_pages disable set
In-Reply-To: <20080522203800.47366817@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0805221405500.14724@gandalf.stny.rr.com>
References: <20080522042215.584408893@goodmis.org> <20080522042301.622087604@goodmis.org>
 <20080522203800.47366817@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka Paalanen pointed out that I didn't set the tracing_disabled flag
when check_pages failed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-05-22 11:44:51.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-05-22 14:03:51.000000000 -0400
@@ -251,7 +251,7 @@ __update_max_tr(struct trace_array *tr,

 #define CHECK_COND(cond)			\
 	if (unlikely(cond)) {			\
-		tracing_disabled = 0;		\
+		tracing_disabled = 1;		\
 		WARN_ON(1);			\
 		return -1;			\
 	}


