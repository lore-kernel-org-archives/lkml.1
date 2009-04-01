Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZDAKO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZDAKO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZDAKNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:13:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:39968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbZDAKNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:13:48 -0400
Date: Wed, 1 Apr 2009 10:13:07 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090330171023.327144324@chello.nl>
References: <20090330171023.327144324@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: kerneltop: simplify data_head read
Message-ID: <tip-b5b7e234c3d14eb614998ce5a96719baf146c71c@git.kernel.org>
Git-Commit-ID: b5b7e234c3d14eb614998ce5a96719baf146c71c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 10:13:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5b7e234c3d14eb614998ce5a96719baf146c71c
Gitweb:     http://git.kernel.org/tip/b5b7e234c3d14eb614998ce5a96719baf146c71c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Mar 2009 19:07:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Apr 2009 11:33:33 +0200

perf_counter: kerneltop: simplify data_head read

Now that the kernel side changed, match up again.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090330171023.327144324@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/kerneltop.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/Documentation/perf_counter/kerneltop.c b/Documentation/perf_counter/kerneltop.c
index fda1438..2779c57 100644
--- a/Documentation/perf_counter/kerneltop.c
+++ b/Documentation/perf_counter/kerneltop.c
@@ -1125,22 +1125,10 @@ struct mmap_data {
 static unsigned int mmap_read_head(struct mmap_data *md)
 {
 	struct perf_counter_mmap_page *pc = md->base;
-	unsigned int seq, head;
-
-repeat:
-	rmb();
-	seq = pc->lock;
-
-	if (unlikely(seq & 1)) {
-		cpu_relax();
-		goto repeat;
-	}
+	int head;
 
 	head = pc->data_head;
-
 	rmb();
-	if (pc->lock != seq)
-		goto repeat;
 
 	return head;
 }
