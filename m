Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbXIZRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbXIZRKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761535AbXIZRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:08:57 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38597
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760377AbXIZRI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:08:56 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188770400"; 
   d="scan'208";a="3292263"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 8/8] taskstats: avoid breaking binary compatibility between
	taskstats v6 and before
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Michael Neuling <mikey@neuling.org>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 26 Sep 2007 19:08:54 +0200
Message-ID: <20070926170854.31221.57986.stgit@cheypa.inria.fr>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Place fields added in v6 at the end of the struct.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 include/linux/taskstats.h |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
index 92bfd1c..dc6850c 100644
--- a/include/linux/taskstats.h
+++ b/include/linux/taskstats.h
@@ -85,12 +85,9 @@ struct taskstats {
 	 * On some architectures, value will adjust for cpu time stolen
 	 * from the kernel in involuntary waits due to virtualization.
 	 * Value is cumulative, in nanoseconds, without a corresponding count
-	 * and wraps around to zero silently on overflow.  The
-	 * _scaled_ version accounts for cpus which can scale the
-	 * number of instructions executed each cycle.
+	 * and wraps around to zero silently on overflow.
 	 */
 	__u64	cpu_run_real_total;
-	__u64	cpu_scaled_run_real_total;
 
 	/* cpu "virtual" running time
 	 * Uses time intervals seen by the kernel i.e. no adjustment
@@ -146,9 +143,6 @@ struct taskstats {
 	__u64	read_syscalls;		/* read syscalls */
 	__u64	write_syscalls;		/* write syscalls */
 
-	/* time accounting for SMT machines */
-	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
-	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
 	/* Extended accounting fields end */
 
 #define TASKSTATS_HAS_IO_ACCOUNTING
@@ -159,6 +153,16 @@ struct taskstats {
 
 	__u64  nvcsw;			/* voluntary_ctxt_switches */
 	__u64  nivcsw;			/* nonvoluntary_ctxt_switches */
+
+	/*
+	 * Same as cpu_run_real_total but accounts for cpus which can scale the
+	 * number of instructions executed each cycle.
+	 */
+	__u64	cpu_scaled_run_real_total;
+
+	/* time accounting for SMT machines */
+	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
+	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
 };
 
 
