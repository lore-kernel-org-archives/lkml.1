Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZEHUit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZEHUit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZEHUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:38:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953AbZEHUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:38:29 -0400
Message-Id: <20090508203827.665792546@goodmis.org>
References: <20090508203605.361898511@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 16:36:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 1/2] tracing: initialize return value for __ftrace_set_clr_event
Content-Disposition: inline; filename=0001-tracing-initialize-return-value-for-__ftrace_set_cl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Commit 8f31bfe538ebafac187d2d4465a92e1d9ee6d8c2
tracing/events: clean up for ftrace_set_clr_event()

Moved out the code for ftrace_set_clr_event into a helper funciton but
did not initialize the return value. As a result, we do not warn about
a typo in the echoing of events in set_event.

This patch restores the old warning:

 # echo foobar > set_event
-bash: echo: write error: Invalid argument

[ Impact: restore warning of invalid entries to set_event ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index df394bc..2eecb87 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -118,7 +118,7 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 				  const char *event, int set)
 {
 	struct ftrace_event_call *call;
-	int ret;
+	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
-- 
1.6.2.4

-- 
