Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYKYVsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYKYVsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYKYVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:45:13 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:60822 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYKYVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:45:11 -0500
From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 6/6] getdelays.c: Show utime, stime,
	and scaled variants of the two
To: "Darrick J. Wong" <djwong@us.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar.sarma@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 13:45:08 -0800
Message-ID: <20081125214508.22900.79143.stgit@elm3a70.beaverton.ibm.com>
In-Reply-To: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
References: <20081125214437.22900.82384.stgit@elm3a70.beaverton.ibm.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since utime, stime, scaled_utime and scaled_stime have been available
via the taskstats interface for a while, modify the helper program to
show those values.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 Documentation/accounting/getdelays.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index cc49400..1894894 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -199,7 +199,8 @@ void print_delayacct(struct taskstats *t)
 	       "SWAP  %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "RECLAIM  %12s%15s\n"
-	       "      %15llu%15llu\n",
+	       "      %15llu%15llu\n"
+	       "TIME utime=%llu stime=%llu sutime=%llu sstime=%llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       (unsigned long long)t->cpu_count,
 	       (unsigned long long)t->cpu_run_real_total,
@@ -213,7 +214,11 @@ void print_delayacct(struct taskstats *t)
 	       (unsigned long long)t->swapin_delay_total,
 	       "count", "delay total",
 	       (unsigned long long)t->freepages_count,
-	       (unsigned long long)t->freepages_delay_total);
+	       (unsigned long long)t->freepages_delay_total,
+	       (unsigned long long)t->ac_utime,
+	       (unsigned long long)t->ac_stime,
+	       (unsigned long long)t->ac_utimescaled,
+	       (unsigned long long)t->ac_stimescaled);
 }
 
 void task_context_switch_counts(struct taskstats *t)

