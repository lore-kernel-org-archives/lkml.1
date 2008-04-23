Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYDWJSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYDWJSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYDWJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:18:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:43252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYDWJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:18:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,698,1199692800"; 
   d="scan'208";a="273700255"
Subject: [patch]cpufreq state info wrong after resume
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 17:21:13 +0800
Message-Id: <1208942473.6630.2.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes old_index != stat->last_index, see cpufreq_update_policy, bios
can change cpu setting in resume. In my test, after resume cpu is in
lowest speed, but the stat info shows cpu is in full speed. This patch
makes the stat info correct after a resume. 

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 070421a..78bd2f3 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -284,7 +284,7 @@ cpufreq_stat_notifier_trans (struct notifier_block *nb, unsigned long val,
 	if (!stat)
 		return 0;
 
-	old_index = freq_table_get_index(stat, freq->old);
+	old_index = stat->last_index;
 	new_index = freq_table_get_index(stat, freq->new);
 
 	cpufreq_stats_update(freq->cpu);


