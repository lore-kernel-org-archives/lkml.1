Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZJ1JiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZJ1JiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZJ1JiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:38:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63921 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbZJ1JiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:38:08 -0400
Message-ID: <4AE810BD.3070009@cn.fujitsu.com>
Date: Wed, 28 Oct 2009 17:37:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/filters: Fix to make system filter work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fce29d15b59245597f7f320db4a9f2be0f5fb512
("tracing/filters: Refactor subsystem filter code")
broke system filter accidentally.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 21d3475..50504cb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1230,12 +1230,12 @@ static int replace_system_preds(struct event_subsystem *system,
 				struct filter_parse_state *ps,
 				char *filter_string)
 {
-	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 	bool fail = true;
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
+		struct event_filter *filter = call->filter;
 
 		if (!call->define_fields)
 			continue;
-- 
1.6.3

