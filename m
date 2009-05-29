Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZE2Ijx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZE2Ijx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbZE2Ijq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:39:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756465AbZE2Ijp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:39:45 -0400
Message-ID: <4A1F9FA6.3030906@cn.fujitsu.com>
Date: Fri, 29 May 2009 16:41:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/filters: strloc should be unsigned short
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to update filter code accordingly in
"tracing/events: change the type of __str_loc_item to unsigned short"
(commt b0aae68cc5508f3c2fbf728988c954db4c8b8a53)

It can cause system crash:

 # echo 1 > tracing/events/irq/irq_handler_entry/enable
 # echo 'name == eth0' > /mnt/tracing/events/irq/irq_handler_entry/filter

[ Impact: fix system crash while filtering on __string() field ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index a7430b1..a854eed 100644
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
1.5.4.rc3

