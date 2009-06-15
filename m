Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbZFOOWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbZFOOWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZFOOWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:22:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbZFOOWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:22:15 -0400
Date: Mon, 15 Jun 2009 14:21:31 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <18998.12884.787039.22202@cargo.ozlabs.ibm.com>
References: <18998.12884.787039.22202@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Fix two compile warnings
Message-ID: <tip-90c8f954534ba15e4542ab00dd9f0e58b071518c@git.kernel.org>
Git-Commit-ID: 90c8f954534ba15e4542ab00dd9f0e58b071518c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 15 Jun 2009 14:21:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90c8f954534ba15e4542ab00dd9f0e58b071518c
Gitweb:     http://git.kernel.org/tip/90c8f954534ba15e4542ab00dd9f0e58b071518c
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Mon, 15 Jun 2009 21:36:52 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Jun 2009 16:12:25 +0200

perf_counter: powerpc: Fix two compile warnings

This fixes a couple of compile warnings that crept into the powerpc
perf_counter code recently:

   CC      arch/powerpc/kernel/perf_counter.o
 arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
 arch/powerpc/kernel/perf_counter.c:1016: warning: unused variable 'addr'
 arch/powerpc/kernel/perf_counter.c: In function 'hw_perf_counter_init':
 arch/powerpc/kernel/perf_counter.c:891: warning: 'ev' may be used uninitialized in this function

Stephen Rothwell reported this against linux-next as well.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18998.12884.787039.22202@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index bb20238..e6dc185 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -913,6 +913,8 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	case PERF_TYPE_RAW:
 		ev = counter->attr.config;
 		break;
+	default:
+		return ERR_PTR(-EINVAL);
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
@@ -1013,7 +1015,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	u64 period = counter->hw.sample_period;
 	s64 prev, delta, left;
 	int record = 0;
-	u64 addr, mmcra, sdsync;
+	u64 mmcra, sdsync;
 
 	/* we don't have to worry about interrupts here */
 	prev = atomic64_read(&counter->hw.prev_count);
