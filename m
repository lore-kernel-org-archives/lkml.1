Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZBCQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZBCQsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZBCQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:47:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:55978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZBCQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:54 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/7] CPUFREQ: ondemand/conservative: deprecate sampling_rate{min,max}
Date: Tue,  3 Feb 2009 17:46:41 +0100
Message-Id: <1233679606-1971-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same info can be obtained via the transition_latency sysfs file

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 Documentation/cpu-freq/governors.txt   |   10 ++++++++--
 drivers/cpufreq/cpufreq_conservative.c |    4 ++++
 drivers/cpufreq/cpufreq_ondemand.c     |    5 +++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index 5b0cfa6..9b18512 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -119,8 +119,14 @@ want the kernel to look at the CPU usage and to make decisions on
 what to do about the frequency.  Typically this is set to values of
 around '10000' or more.
 
-show_sampling_rate_(min|max): the minimum and maximum sampling rates
-available that you may set 'sampling_rate' to.
+show_sampling_rate_(min|max): THIS INTERFACE IS DEPRECATED, DON'T USE IT.
+You can use wider ranges now and the general
+cpuinfo_transition_latency variable (cmp. with user-guide.txt) can be
+used to obtain exactly the same info:
+show_sampling_rate_min = transtition_latency * 500    / 1000
+show_sampling_rate_max = transtition_latency * 500000 / 1000
+(divided by 1000 is to illustrate that sampling rate is in us and
+transition latency is exported ns).
 
 up_threshold: defines what the average CPU usage between the samplings
 of 'sampling_rate' needs to be for the kernel to make a decision on
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 0320962..5ba0a3f 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -140,11 +140,15 @@ static struct notifier_block dbs_cpufreq_notifier_block = {
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
+	printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	       "sysfs file is deprecated - used by: %s\n", current->comm);
 	return sprintf (buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
+	printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	       "sysfs file is deprecated - used by: %s\n", current->comm);
 	return sprintf (buf, "%u\n", MIN_SAMPLING_RATE);
 }
 
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 6f45b16..4b42e36 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -21,6 +21,7 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 #include <linux/ktime.h>
+#include <linux/sched.h>
 
 /*
  * dbs is used in this file as a shortform for demandbased switching
@@ -203,11 +204,15 @@ static void ondemand_powersave_bias_init(void)
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
+	printk(KERN_INFO "CPUFREQ: ondemand sampling_rate_max "
+	       "sysfs file is deprecated - used by: %s\n", current->comm);
 	return sprintf (buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
+	printk(KERN_INFO "CPUFREQ: ondemand sampling_rate_min "
+	       "sysfs file is deprecated - used by: %s\n", current->comm);
 	return sprintf (buf, "%u\n", MIN_SAMPLING_RATE);
 }
 
-- 
1.6.0.2

