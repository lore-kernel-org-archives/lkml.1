Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZFOMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZFOMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbZFOMFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:05:42 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35610 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096AbZFOMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:05:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18998.12884.787039.22202@cargo.ozlabs.ibm.com>
Date: Mon, 15 Jun 2009 21:36:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: perf_counter: powerpc: Fix two compile warnings
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a couple of compile warnings that crept into the powerpc
perf_counter code recently:

  CC      arch/powerpc/kernel/perf_counter.o
arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
arch/powerpc/kernel/perf_counter.c:1016: warning: unused variable 'addr'
arch/powerpc/kernel/perf_counter.c: In function 'hw_perf_counter_init':
arch/powerpc/kernel/perf_counter.c:891: warning: 'ev' may be used uninitialized in this function

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/perf_counter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
