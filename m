Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZICO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZICO24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZICO2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:28:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:55086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZICO2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:28:54 -0400
Date: Thu, 3 Sep 2009 14:28:15 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf trace: Fix read_string()
Message-ID: <tip-6f4596d9312ba5fbf5f3231ef484823c4e684d2e@git.kernel.org>
Git-Commit-ID: 6f4596d9312ba5fbf5f3231ef484823c4e684d2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 03 Sep 2009 14:28:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f4596d9312ba5fbf5f3231ef484823c4e684d2e
Gitweb:     http://git.kernel.org/tip/6f4596d9312ba5fbf5f3231ef484823c4e684d2e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 3 Sep 2009 16:22:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Sep 2009 16:22:45 +0200

perf trace: Fix read_string()

We did not account for the enclosing \0. Depending on what malloc()
gave us this resulted in corrupted version string printouts.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-read.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index b12e490..a1217a1 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -113,8 +113,11 @@ static char *read_string(void)
 		}
 	}
 
+	/* trailing \0: */
+	i++;
+
 	/* move the file descriptor to the end of the string */
-	r = lseek(input_fd, -(r - (i+1)), SEEK_CUR);
+	r = lseek(input_fd, -(r - i), SEEK_CUR);
 	if (r < 0)
 		die("lseek");
 
