Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZDHKnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZDHKnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZDHKnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:43:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:56226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZDHKnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:43:05 -0400
Date: Wed, 8 Apr 2009 10:42:30 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18908.31922.411398.147810@cargo.ozlabs.ibm.com>
References: <18908.31922.411398.147810@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: fix powerpc build
Message-ID: <tip-dc66270b51a62b1a6888d5309229e638a305c47b@git.kernel.org>
Git-Commit-ID: dc66270b51a62b1a6888d5309229e638a305c47b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 10:42:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc66270b51a62b1a6888d5309229e638a305c47b
Gitweb:     http://git.kernel.org/tip/dc66270b51a62b1a6888d5309229e638a305c47b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Wed, 8 Apr 2009 20:30:10 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 12:39:27 +0200

perf_counter: fix powerpc build

Commit 4af4998b ("perf_counter: rework context time") changed struct
perf_counter_context to have a 'time' field instead of a 'time_now'
field, but neglected to fix the place in the powerpc perf_counter.c
where the time_now field was accessed.  This fixes it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18908.31922.411398.147810@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index f88c35d..0e56513 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -457,8 +457,7 @@ static void counter_sched_in(struct perf_counter *counter, int cpu)
 {
 	counter->state = PERF_COUNTER_STATE_ACTIVE;
 	counter->oncpu = cpu;
-	counter->tstamp_running += counter->ctx->time_now -
-		counter->tstamp_stopped;
+	counter->tstamp_running += counter->ctx->time - counter->tstamp_stopped;
 	if (is_software_counter(counter))
 		counter->hw_ops->enable(counter);
 }
