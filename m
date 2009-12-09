Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZLIT0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZLIT0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZLIT0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:26:17 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:54126 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbZLIT0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:26:13 -0500
Date: Wed, 9 Dec 2009 20:26:18 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/12] tools/perf: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092026000.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

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

---
 tools/perf/util/probe-event.c       |    2 +-
 tools/perf/util/trace-event-parse.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -376,7 +376,7 @@ static void clear_probe_point(struct pro
 		free(pp->args);
 	for (i = 0; i < pp->found; i++)
 		free(pp->probes[i]);
-	memset(pp, 0, sizeof(pp));
+	memset(pp, 0, sizeof(*pp));
 }
 
 /* List up current perf-probe events */
diff -u -p a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1477,7 +1477,7 @@ process_fields(struct event *event, stru
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
+		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
 		field->value = strdup(value);
