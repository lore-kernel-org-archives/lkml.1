Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYEZObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYEZObp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYEZObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:31:36 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:50240 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbYEZObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:31:35 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 3/3] Print scaled utime and stime in getdelays
To: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Date: Mon, 26 May 2008 20:01:53 +0530
Message-ID: <20080526143153.24680.87356.stgit@drishya.in.ibm.com>
In-Reply-To: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add print in getdelays program to show scaled stats from taskstats.
* Normal utime and stime are printed in micro seconds
* Sacled utime and stime are printed in micro seconds
* Total scaled run real time is printed in nano seconds

The values in the taskstats are printed as is hence the change in units.

getdelays -d should print these values.
Prefered cmdline is getdelays -l -p -m0-3 to get the final delay count
at exit.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 Documentation/accounting/getdelays.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 40121b5..f695563 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -197,13 +197,22 @@ void print_delayacct(struct taskstats *t)
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n",
+               "      %15llu%15llu\n"
+               "      %15s%15s\n"
+               "      %15llu%15llu\n"
+               "      %15s%15s%15s\n"
+               "      %15llu%15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
 	       "count", "delay total",
 	       t->blkio_count, t->blkio_delay_total,
-	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
+	       "count", "delay total", t->swapin_count, t->swapin_delay_total,
+	       "utime", "stime",
+	       t->ac_utime, t->ac_stime,
+               "scaled utime", "scaled stime", "total",
+               t->ac_utimescaled, t->ac_stimescaled, 
+               t->cpu_scaled_run_real_total);
 }
 
 void task_context_switch_counts(struct taskstats *t)

