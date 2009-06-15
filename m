Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbZFOSOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbZFOSOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764974AbZFOSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:14:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636AbZFOSON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:14:13 -0400
Date: Mon, 15 Jun 2009 18:13:50 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4A35B905.3090500@cn.fujitsu.com>
References: <4A35B905.3090500@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: strloc should be unsigned short
Message-ID: <tip-0ac2058f686a19fe8ab25c4f3104fc1580dce7cf@git.kernel.org>
Git-Commit-ID: 0ac2058f686a19fe8ab25c4f3104fc1580dce7cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 18:13:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ac2058f686a19fe8ab25c4f3104fc1580dce7cf
Gitweb:     http://git.kernel.org/tip/0ac2058f686a19fe8ab25c4f3104fc1580dce7cf
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 15 Jun 2009 10:59:17 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 15 Jun 2009 11:37:18 -0400

tracing/filters: strloc should be unsigned short

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
 
