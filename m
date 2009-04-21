Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZDUKJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZDUKJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 06:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZDUKIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 06:08:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:42140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZDUKIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 06:08:46 -0400
Date: Tue, 21 Apr 2009 10:08:12 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49ED8DD2.2070700@cn.fujitsu.com>
References: <49ED8DD2.2070700@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filters: don't remove old filters when failed to write subsys->filter
Message-ID: <tip-e8082f3f5a17d7a7bfc7dd1050a3f958dc034e9a@git.kernel.org>
Git-Commit-ID: e8082f3f5a17d7a7bfc7dd1050a3f958dc034e9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 10:08:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8082f3f5a17d7a7bfc7dd1050a3f958dc034e9a
Gitweb:     http://git.kernel.org/tip/e8082f3f5a17d7a7bfc7dd1050a3f958dc034e9a
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 21 Apr 2009 17:11:46 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 11:58:27 +0200

tracing/filters: don't remove old filters when failed to write subsys->filter

If writing subsys->filter returns EINVAL or ENOSPC, the original
filters in subsys/ and subsys/events/ will be removed. This is
definitely wrong.

[ Impact: fix filter setting semantics on error condition ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <49ED8DD2.2070700@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 672b195..9ea55a7 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -600,7 +600,6 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	err = filter_add_subsystem_pred(system, pred);
 	if (err < 0) {
-		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
 		return err;
 	}
