Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZKWLzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZKWLzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbZKWLzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:55:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:56175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbZKWLzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:55:19 -0500
Date: Mon, 23 Nov 2009 11:54:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091123103819.689055515@chello.nl>
References: <20091123103819.689055515@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Disable events when we detach them
Message-ID: <tip-2e2af50b1fab3c40636839a7f439c167ae559533@git.kernel.org>
Git-Commit-ID: 2e2af50b1fab3c40636839a7f439c167ae559533
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e2af50b1fab3c40636839a7f439c167ae559533
Gitweb:     http://git.kernel.org/tip/2e2af50b1fab3c40636839a7f439c167ae559533
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Nov 2009 11:37:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:49:56 +0100

perf_events: Disable events when we detach them

If we leave the event in STATE_INACTIVE, any read of the event
after the detach will increase the running count but not the
enabled count and cause funny scaling artefacts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091123103819.689055515@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1f14481..fb851ec 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -294,6 +294,8 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
+	event->state = PERF_EVENT_STATE_OFF;
+
 	/*
 	 * If this was a group event with sibling events then
 	 * upgrade the siblings to singleton events by adding them
