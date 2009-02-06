Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZBFAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZBFAP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZBFAPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:15:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZBFAPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:15:16 -0500
Date: Fri, 6 Feb 2009 01:15:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ring_buffer: remove unused flags parameter, fix
Message-ID: <20090206001500.GA30095@elte.hu>
References: <20090205181256.GH17653@ghostprotocols.net> <20090206000223.GB16040@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206000223.GB16040@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Small fixlet below, applied to tip:tracing/ftrace.

	Ingo

--------------->
>From 304cc6ae1bf7a8e6d00053fbe0b7e2b26cdddda2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 6 Feb 2009 01:12:02 +0100
Subject: [PATCH] ring_buffer: remove unused flags parameter, fix

Oprofile's ring-buffer use was not considered.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/oprofile/cpu_buffer.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index e76d715..f0e99d4 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -161,7 +161,7 @@ struct op_sample
 {
 	entry->event = ring_buffer_lock_reserve
 		(op_ring_buffer_write, sizeof(struct op_sample) +
-		 size * sizeof(entry->sample->data[0]), &entry->irq_flags);
+		 size * sizeof(entry->sample->data[0]));
 	if (entry->event)
 		entry->sample = ring_buffer_event_data(entry->event);
 	else
@@ -178,8 +178,7 @@ struct op_sample
 
 int op_cpu_buffer_write_commit(struct op_entry *entry)
 {
-	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
-					 entry->irq_flags);
+	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event);
 }
 
 struct op_sample *op_cpu_buffer_read_entry(struct op_entry *entry, int cpu)
