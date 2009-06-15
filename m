Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbZFOPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbZFOPps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761690AbZFOPoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:44:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbZFOPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:44:09 -0400
Message-Id: <20090615154411.608239843@goodmis.org>
References: <20090615154226.058101204@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Jun 2009 11:42:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 6/7] tracing/filters: strloc should be unsigned short
Content-Disposition: inline; filename=0006-tracing-filters-strloc-should-be-unsigned-short.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

I forgot to update filter code accordingly in
"tracing/events: change the type of __str_loc_item to unsigned short"
(commt b0aae68cc5508f3c2fbf728988c954db4c8b8a53)

It can cause system crash:

 # echo 1 > tracing/events/irq/irq_handler_entry/enable
 # echo 'name == eth0' > tracing/events/irq/irq_handler_entry/filter

[ Impact: fix crash while filtering on __string() field ]

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A35B905.3090500@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1d81923..b24ab0e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -178,7 +178,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 static int filter_pred_strloc(struct filter_pred *pred, void *event,
 			      int val1, int val2)
 {
-	int str_loc = *(int *)(event + pred->offset);
+	unsigned short str_loc = *(unsigned short *)(event + pred->offset);
 	char *addr = (char *)(event + str_loc);
 	int cmp, match;
 
-- 
1.6.3.1

-- 
