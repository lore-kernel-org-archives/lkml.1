Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbZLJHul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbZLJHul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbZLJHuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:50:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:46525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760725AbZLJHub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:50:31 -0500
Date: Thu, 10 Dec 2009 07:50:16 GMT
From: tip-bot for Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, julia@diku.dk,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0912092026000.1870@ask.diku.dk>
References: <Pine.LNX.4.64.0912092026000.1870@ask.diku.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Correct size given to memset
Message-ID: <tip-5660ce34241ab204bf78fbcaa5e09318c2748d37@git.kernel.org>
Git-Commit-ID: 5660ce34241ab204bf78fbcaa5e09318c2748d37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5660ce34241ab204bf78fbcaa5e09318c2748d37
Gitweb:     http://git.kernel.org/tip/5660ce34241ab204bf78fbcaa5e09318c2748d37
Author:     Julia Lawall <julia@diku.dk>
AuthorDate: Wed, 9 Dec 2009 20:26:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:30:26 +0100

perf tools: Correct size given to memset

Memset should be given the size of the structure, not the size
of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <Pine.LNX.4.64.0912092026000.1870@ask.diku.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c       |    2 +-
 tools/perf/util/trace-event-parse.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9480d99..d14a458 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -376,7 +376,7 @@ static void clear_probe_point(struct probe_point *pp)
 		free(pp->args);
 	for (i = 0; i < pp->found; i++)
 		free(pp->probes[i]);
-	memset(pp, 0, sizeof(pp));
+	memset(pp, 0, sizeof(*pp));
 }
 
 /* Show an event */
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6ffe9d6..c5c32be 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1477,7 +1477,7 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
+		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
 		field->value = strdup(value);
