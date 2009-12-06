Return-Path: <linux-kernel-owner+w=401wt.eu-S932559AbZLFJZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbZLFJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZLFJZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:25:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:50398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZLFJZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:25:21 -0500
Date: Sun, 6 Dec 2009 09:24:44 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       julia@diku.dk, hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
References: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Correct size computation in tracepoint_id_to_path()
Message-ID: <tip-59b4caeb797494043f5f3b98a610f5d9b75eefa3@git.kernel.org>
Git-Commit-ID: 59b4caeb797494043f5f3b98a610f5d9b75eefa3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59b4caeb797494043f5f3b98a610f5d9b75eefa3
Gitweb:     http://git.kernel.org/tip/59b4caeb797494043f5f3b98a610f5d9b75eefa3
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Sun, 6 Dec 2009 10:16:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 10:21:59 +0100

perf tools: Correct size computation in tracepoint_id_to_path()

The size argument to zalloc should be the size of desired
structure, not the pointer to it.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
-sizeof(x)
+sizeof(*x)
...+>// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9e5dbd6..448a13b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				path = zalloc(sizeof(path));
+				path = zalloc(sizeof(*path));
 				path->system = malloc(MAX_EVENT_LENGTH);
 				if (!path->system) {
 					free(path);
