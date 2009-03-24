Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZCXH3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZCXH3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbZCXH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:28:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbZCXH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:28:32 -0400
Date: Tue, 24 Mar 2009 07:27:46 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237878851.8339.58.camel@charm-linux>
References: <1237878851.8339.58.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: free pred when clearing filters
Message-ID: <tip-09f1f245c79585383de63e3ca54d0f91824bff3a@git.kernel.org>
Git-Commit-ID: 09f1f245c79585383de63e3ca54d0f91824bff3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 07:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09f1f245c79585383de63e3ca54d0f91824bff3a
Gitweb:     http://git.kernel.org/tip/09f1f245c79585383de63e3ca54d0f91824bff3a
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 24 Mar 2009 02:14:11 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 08:26:51 +0100

tracing/filters: free pred when clearing filters

Impact: fix (small) per trace filter modification memory leak

Free the current pred when clearing the filters via the filter files.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237878851.8339.58.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fdab30d..a938138 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -516,6 +516,7 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (pred->clear) {
 		filter_free_preds(call);
+		filter_free_pred(pred);
 		return cnt;
 	}
 
@@ -581,6 +582,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (pred->clear) {
 		filter_free_subsystem_preds(system);
+		filter_free_pred(pred);
 		return cnt;
 	}
 
