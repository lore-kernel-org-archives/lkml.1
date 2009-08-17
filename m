Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZHQVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZHQVHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZHQVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:07:53 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47999 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbZHQVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:07:52 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 17:07:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ncbDRGF8sFORO8oe+7aWL3tj0qBHAiRNMvtXhTWDUj/fy3Os7ksGHkO8dxugUT90tx
         6hP6vCY3pq/aAMKWevUJ9zUfWmzqbLCRpjGfkmlJIax9RQjn6KexOqxI8m1U2/1n/5Qn
         ghdSK9OIwjGXtGLrElYfWVV+9gtOMGy1SayyA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/4] perf tools: Fix spelling mistake in callchain error
Date: Mon, 17 Aug 2009 23:07:48 +0200
Message-Id: <1250543271-8383-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090817144007.GC3602@elte.hu>
References: <20090817144007.GC3602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running perf report -g in a perf.data file that hasn't been
recorded in callchain mode, the error reported has a spelling issue:

	./perf report -g
	selected -c but no callchain data. Did you call perf record without -g?

Fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1e3ad22..ed1fdab 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1401,7 +1401,7 @@ static int __cmd_report(void)
 			exit(-1);
 		}
 		if (callchain) {
-			fprintf(stderr, "selected -c but no callchain data."
+			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			exit(-1);
-- 
1.6.2.3

