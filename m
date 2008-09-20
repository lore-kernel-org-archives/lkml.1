Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYITOum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYITOum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYITOue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:50:34 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:46721 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYITOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:50:33 -0400
Date: Sat, 20 Sep 2008 16:50:08 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: davej@codemonkey.org.uk
cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: Don't export governors for default governor
Message-ID: <alpine.LNX.2.00.0809201643470.22510@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 20 Sep 2008 14:50:31 +0000
	Bayes: 0.4949 Tokens: new, 214; hammy, 2; neutral, 2; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4949]
X-Spam-Signature: 621f325487928e9285cbd5368336cf64afb97dc5
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to export the governors for use as the default governor,
because the default governor will be built-in anyway and we can access
the symbol directly.

This also fixes the following sparse warnings:

drivers/cpufreq/cpufreq_conservative.c:578:25: warning: symbol 'cpufreq_gov_conservative' was not declared. Should it be static?
drivers/cpufreq/cpufreq_ondemand.c:582:25: warning: symbol 'cpufreq_gov_ondemand' was not declared. Should it be static?
drivers/cpufreq/cpufreq_performance.c:39:25: warning: symbol 'cpufreq_gov_performance' was not declared. Should it be static?
drivers/cpufreq/cpufreq_powersave.c:38:25: warning: symbol 'cpufreq_gov_powersave' was not declared. Should it be static?
drivers/cpufreq/cpufreq_userspace.c:190:25: warning: symbol 'cpufreq_gov_userspace' was not declared. Should it be static?

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/cpufreq/cpufreq_conservative.c |    4 +++-
 drivers/cpufreq/cpufreq_ondemand.c     |    4 +++-
 drivers/cpufreq/cpufreq_performance.c  |    4 +++-
 drivers/cpufreq/cpufreq_powersave.c    |    4 +++-
 drivers/cpufreq/cpufreq_userspace.c    |    4 +++-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index c1dd266..cf0ab1b 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -576,13 +576,15 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_conservative = {
 	.name			= "conservative",
 	.governor		= cpufreq_governor_dbs,
 	.max_transition_latency	= TRANSITION_LATENCY_LIMIT,
 	.owner			= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_conservative);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index aaa9e19..35e63e9 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -626,13 +626,15 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+static
+#endif
 struct cpufreq_governor cpufreq_gov_ondemand = {
 	.name			= "ondemand",
 	.governor		= cpufreq_governor_dbs,
 	.max_transition_latency = TRANSITION_LATENCY_LIMIT,
 	.owner			= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_ondemand);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..7e2e515 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -36,12 +36,14 @@ static int cpufreq_governor_performance(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE_MODULE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_performance = {
 	.name		= "performance",
 	.governor	= cpufreq_governor_performance,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_performance);
 
 
 static int __init cpufreq_gov_performance_init(void)
diff --git a/drivers/cpufreq/cpufreq_powersave.c b/drivers/cpufreq/cpufreq_powersave.c
index 88d2f44..e6db5fa 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -35,12 +35,14 @@ static int cpufreq_governor_powersave(struct cpufreq_policy *policy,
 	return 0;
 }
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_powersave = {
 	.name		= "powersave",
 	.governor	= cpufreq_governor_powersave,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_powersave);
 
 static int __init cpufreq_gov_powersave_init(void)
 {
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 32244aa..1442bba 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -187,6 +187,9 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 }
 
 
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
+static
+#endif
 struct cpufreq_governor cpufreq_gov_userspace = {
 	.name		= "userspace",
 	.governor	= cpufreq_governor_userspace,
@@ -194,7 +197,6 @@ struct cpufreq_governor cpufreq_gov_userspace = {
 	.show_setspeed	= show_speed,
 	.owner		= THIS_MODULE,
 };
-EXPORT_SYMBOL(cpufreq_gov_userspace);
 
 static int __init cpufreq_gov_userspace_init(void)
 {
