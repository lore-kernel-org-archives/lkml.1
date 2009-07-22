Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZGVNJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZGVNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZGVNJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:09:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60101 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZGVNJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:09:58 -0400
Date: Wed, 22 Jul 2009 23:05:46 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Fix throttle/unthrottle event logging
Message-ID: <20090722130546.GE9029@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Right now we only print PERF_EVENT_THROTTLE + 1 (ie PERF_EVENT_UNTHROTTLE).
Fix this to print both a throttle and unthrottle event.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/perf_counter.c
===================================================================
--- linux.trees.git.orig/kernel/perf_counter.c	2009-07-22 22:43:36.000000000 +1000
+++ linux.trees.git/kernel/perf_counter.c	2009-07-22 22:55:10.000000000 +1000
@@ -3195,7 +3195,7 @@ static void perf_log_throttle(struct per
 		u64				stream_id;
 	} throttle_event = {
 		.header = {
-			.type = PERF_EVENT_THROTTLE + 1,
+			.type = PERF_EVENT_THROTTLE,
 			.misc = 0,
 			.size = sizeof(throttle_event),
 		},
@@ -3204,6 +3204,9 @@ static void perf_log_throttle(struct per
 		.stream_id	= counter->id,
 	};
 
+	if (enable)
+		throttle_event.header.type = PERF_EVENT_UNTHROTTLE;
+
 	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 1, 0);
 	if (ret)
 		return;
