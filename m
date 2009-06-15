Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZFOC5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZFOC5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZFOC5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:57:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZFOC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:57:44 -0400
Message-ID: <4A35B905.3090500@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 10:59:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing/filters: strloc should be unsigned short
References: <4A35B84B.40904@cn.fujitsu.com>
In-Reply-To: <4A35B84B.40904@cn.fujitsu.com>
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
 # echo 'name == eth0' > tracing/events/irq/irq_handler_entry/filter

[ Impact: fix crash while filtering on __string() field ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3

