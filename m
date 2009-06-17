Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbZFQLOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbZFQLOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764807AbZFQLOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:14:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:56311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763007AbZFQLOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:14:11 -0400
Date: Wed, 17 Jun 2009 11:13:29 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A375A30.9060802@cn.fujitsu.com>
References: <4A375A30.9060802@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/filters: free filter_string in destroy_preds()
Message-ID: <tip-57be88878e7aa38750384704d811485a607bbda4@git.kernel.org>
Git-Commit-ID: 57be88878e7aa38750384704d811485a607bbda4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 11:13:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57be88878e7aa38750384704d811485a607bbda4
Gitweb:     http://git.kernel.org/tip/57be88878e7aa38750384704d811485a607bbda4
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 16 Jun 2009 16:39:12 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 16 Jun 2009 16:25:35 -0400

tracing/filters: free filter_string in destroy_preds()

filter->filter_string is not freed when unloading a module:

 # insmod trace-events-sample.ko
 # echo "bar < 100" > /mnt/tracing/events/sample/foo_bar/filter
 # rmmod trace-events-sample.ko

[ Impact: fix memory leak when unloading module ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A375A30.9060802@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace_events_filter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index b24ab0e..d9f01c1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,7 @@ void destroy_preds(struct ftrace_event_call *call)
 			filter_free_pred(filter->preds[i]);
 	}
 	kfree(filter->preds);
+	kfree(filter->filter_string);
 	kfree(filter);
 	call->filter = NULL;
 }
