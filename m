Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbZLFJQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbZLFJQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZLFJQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:16:27 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47578 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbZLFJQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:16:25 -0500
Date: Sun, 6 Dec 2009 10:16:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] tools/perf/util: correct size computation
Message-ID: <Pine.LNX.4.64.0912061016120.20858@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The size argument to zalloc should be the size of desired structure,
not the pointer to it.

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

---
 tools/perf/util/parse-events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				path = zalloc(sizeof(path));
+				path = zalloc(sizeof(*path));
 				path->system = malloc(MAX_EVENT_LENGTH);
 				if (!path->system) {
 					free(path);
