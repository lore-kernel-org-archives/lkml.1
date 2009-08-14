Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZHNS0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZHNS0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbZHNS0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:26:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZHNS0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:26:43 -0400
Date: Fri, 14 Aug 2009 15:26:32 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] perf record: Fix typo in pid_synthesize_comm_event
Message-ID: <20090814182632.GF3490@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using 'fd' locally, but there was a global 'fd' too, so when
converting from open to fopen the test made against fd should be made
against 'fp', but since we have that global...

Reported-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e67c4fa..65b4115 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -201,7 +201,7 @@ static pid_t pid_synthesize_comm_event(pid_t pid, int full)
 	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
 	fp = fopen(filename, "r");
-	if (fd == NULL) {
+	if (fp == NULL) {
 		/*
 		 * We raced with a task exiting - just return:
 		 */
-- 
1.6.2.5
