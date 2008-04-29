Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYD2Urp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYD2Urp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762133AbYD2Uq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:46:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:25435 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbYD2Uq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=tj8lM04sSMf2kFkfjGpoJO1mUQo/hjuTHFmf6QF4eZtOMKOXj+zCRag4bjaRvV1VBk37HDTQV/gEiIQNLDxAV33fv/2n8c67Qteglqf9kiwp5E4qMohH5kaCFmKXNoC2nq04xffWN/oDPEsH+RQsQpExQCUQOhG/9yN7Jy+13YI=
Date: Tue, 29 Apr 2008 23:46:48 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] mmiotrace: rename kmmio_probe::user_data to :private.
Message-ID: <20080429234648.650227e9@daedalus.pq.iki.fi>
In-Reply-To: <20080429234021.071f7948@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080429234021.071f7948@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ecd0591bcefb2bbd934de25cadd0f7cb5dd2b7e1 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Tue, 29 Apr 2008 22:56:26 +0300
Subject: [PATCH] mmiotrace: rename kmmio_probe::user_data to :private.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/mmio-mod.c    |    4 ++--
 include/linux/mmiotrace.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 3b04a01..ed0e0e9 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -191,7 +191,7 @@ static void pre(struct kmmio_probe *p, struct pt_regs *regs,
 	struct mmiotrace_rw *my_trace = &get_cpu_var(cpu_trace);
 	const unsigned long instptr = instruction_pointer(regs);
 	const enum reason_type type = get_ins_type(instptr);
-	struct remap_trace *trace = p->user_data;
+	struct remap_trace *trace = p->private;
 
 	/* it doesn't make sense to have more than one active trace per cpu */
 	if (my_reason->active_traces)
@@ -299,7 +299,7 @@ static void ioremap_trace_core(resource_size_t offset, unsigned long size,
 			.len = size,
 			.pre_handler = pre,
 			.post_handler = post,
-			.user_data = trace
+			.private = trace
 		},
 		.phys = offset,
 		.id = atomic_inc_return(&next_id)
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
index 5cbbc37..61d19e1 100644
--- a/include/linux/mmiotrace.h
+++ b/include/linux/mmiotrace.h
@@ -18,7 +18,7 @@ struct kmmio_probe {
 	unsigned long len; /* length of the probe region */
 	kmmio_pre_handler_t pre_handler; /* Called before addr is executed. */
 	kmmio_post_handler_t post_handler; /* Called after addr is executed */
-	void *user_data;
+	void *private;
 };
 
 /* kmmio is active by some kmmio_probes? */
-- 
1.5.3.7

