Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZKWLzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZKWLzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZKWLzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:55:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:56166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbZKWLzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:55:11 -0500
Date: Mon, 23 Nov 2009 11:54:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091123103819.764207355@chello.nl>
References: <20091123103819.764207355@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Update the context time on exit
Message-ID: <tip-5e942bb33371254a474653123cd9e13a4c89ee44@git.kernel.org>
Git-Commit-ID: 5e942bb33371254a474653123cd9e13a4c89ee44
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e942bb33371254a474653123cd9e13a4c89ee44
Gitweb:     http://git.kernel.org/tip/5e942bb33371254a474653123cd9e13a4c89ee44
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:56 +0100

perf_events: Update the context time on exit

It appeared we did call update_event_times() on exit, but we
failed to update the context time, which renders the former
moot.

Locking is a bit iffy, we call update_event_times under
ctx->mutex instead of ctx->lock - the next patch fixes this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091123103819.764207355@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fb851ec..8be2574 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4983,6 +4983,7 @@ void perf_event_exit_task(struct task_struct *child)
 	 * the events from it.
 	 */
 	unclone_ctx(child_ctx);
+	update_context_time(child_ctx);
 	spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*
