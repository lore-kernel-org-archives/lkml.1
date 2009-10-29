Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZJ2IMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZJ2IMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZJ2IMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:12:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZJ2IMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:12:33 -0400
Date: Thu, 29 Oct 2009 08:09:42 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AE810BD.3070009@cn.fujitsu.com>
References: <4AE810BD.3070009@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/filters: Fix to make system filter work
Message-ID: <tip-3ed67776fc23061180896086a206a02be649dd26@git.kernel.org>
Git-Commit-ID: 3ed67776fc23061180896086a206a02be649dd26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ed67776fc23061180896086a206a02be649dd26
Gitweb:     http://git.kernel.org/tip/3ed67776fc23061180896086a206a02be649dd26
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 28 Oct 2009 17:37:01 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:53:20 +0100

tracing/filters: Fix to make system filter work

commit fce29d15b59245597f7f320db4a9f2be0f5fb512
("tracing/filters: Refactor subsystem filter code")
broke system filter accidentally.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AE810BD.3070009@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
