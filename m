Return-Path: <linux-kernel-owner+w=401wt.eu-S1423104AbXDXVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423104AbXDXVDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423114AbXDXVDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:03:25 -0400
Received: from [70.254.190.220] ([70.254.190.220]:56314 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423104AbXDXVDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:03:24 -0400
Date: Tue, 24 Apr 2007 21:03:23 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk
Subject: [RFC] [PATCH] cpufreq: allow full selection of default governors
Message-ID: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches should allow selection of conservative, powersave, and 
ondemand in the kernel configuration.

William Heimbigner
icxcnika@mar.tar.cc

diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff linux-2.6.21-rc7-git6/drivers/cpufreq/Kconfig linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/Kconfig
--- linux-2.6.21-rc7-git6/drivers/cpufreq/Kconfig	2007-04-25 13:03:41.000000000 -0500
+++ linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/Kconfig	2007-04-25 13:08:13.000000000 -0500
@@ -75,6 +75,24 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
  	  program shall be able to set the CPU dynamically without having
  	  to enable the userspace governor manually.

+config CPU_FREQ_DEFAULT_GOV_POWERSAVE
+	bool "powersave"
+	select CPU_FREQ_GOV_POWERSAVE
+	help
+	  Use the CPUFreq governor 'powersave' as default.
+
+config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+	bool "conservative"
+	select CPU_FREQ_GOV_CONSERVATIVE
+	help
+	  Use the CPUFreq governor 'conservative' as the default.
+
+config CPU_FREQ_DEFAULT_GOV_ONDEMAND
+	bool "ondemand"
+	select CPU_FREQ_GOV_ONDEMAND
+	help
+	  Use the CPUFreq governor 'ondemand' as the default.
+
  endchoice

  config CPU_FREQ_GOV_PERFORMANCE
diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_conservative.c linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_conservative.c
--- linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_conservative.c	2007-04-25 13:03:41.000000000 -0500
+++ linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_conservative.c	2007-04-25 09:54:58.000000000 -0500
@@ -551,7 +551,7 @@ static int cpufreq_governor_dbs(struct c
  	return 0;
  }

-static struct cpufreq_governor cpufreq_gov_dbs = {
+struct cpufreq_governor cpufreq_gov_conservative = {
  	.name		= "conservative",
  	.governor	= cpufreq_governor_dbs,
  	.owner		= THIS_MODULE,
@@ -559,7 +559,7 @@ static struct cpufreq_governor cpufreq_g

  static int __init cpufreq_gov_dbs_init(void)
  {
-	return cpufreq_register_governor(&cpufreq_gov_dbs);
+	return cpufreq_register_governor(&cpufreq_gov_conservative);
  }

  static void __exit cpufreq_gov_dbs_exit(void)
@@ -567,7 +567,7 @@ static void __exit cpufreq_gov_dbs_exit(
  	/* Make sure that the scheduled work is indeed not running */
  	flush_scheduled_work();

-	cpufreq_unregister_governor(&cpufreq_gov_dbs);
+	cpufreq_unregister_governor(&cpufreq_gov_conservative);
  }


diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_ondemand.c linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_ondemand.c
--- linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_ondemand.c	2007-04-25 13:03:41.000000000 -0500
+++ linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_ondemand.c	2007-04-25 13:17:00.000000000 -0500
@@ -573,7 +573,7 @@ static int cpufreq_governor_dbs(struct c
  	return 0;
  }

-static struct cpufreq_governor cpufreq_gov_dbs = {
+struct cpufreq_governor cpufreq_gov_ondemand = {
  	.name = "ondemand",
  	.governor = cpufreq_governor_dbs,
  	.owner = THIS_MODULE,
@@ -586,12 +586,12 @@ static int __init cpufreq_gov_dbs_init(v
  		printk(KERN_ERR "Creation of kondemand failed\n");
  		return -EFAULT;
  	}
-	return cpufreq_register_governor(&cpufreq_gov_dbs);
+	return cpufreq_register_governor(&cpufreq_gov_ondemand);
  }

  static void __exit cpufreq_gov_dbs_exit(void)
  {
-	cpufreq_unregister_governor(&cpufreq_gov_dbs);
+	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
  	destroy_workqueue(kondemand_wq);
  }

diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_powersave.c linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_powersave.c
--- linux-2.6.21-rc7-git6/drivers/cpufreq/cpufreq_powersave.c	2007-02-04 12:44:54.000000000 -0600
+++ linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/cpufreq_powersave.c	2007-04-25 08:51:03.000000000 -0500
@@ -35,7 +35,7 @@ static int cpufreq_governor_powersave(st
  	return 0;
  }

-static struct cpufreq_governor cpufreq_gov_powersave = {
+struct cpufreq_governor cpufreq_gov_powersave = {
  	.name		= "powersave",
  	.governor	= cpufreq_governor_powersave,
  	.owner		= THIS_MODULE,

diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff linux-2.6.21-rc7-git6/include/linux/cpufreq.h linux-2.6.21-rc7-git6-hwill/include/linux/cpufreq.h
--- linux-2.6.21-rc7-git6/include/linux/cpufreq.h	2007-04-25 13:04:00.000000000 -0500
+++ linux-2.6.21-rc7-git6-hwill/include/linux/cpufreq.h	2007-04-25 13:10:26.000000000 -0500
@@ -286,6 +286,15 @@ extern struct cpufreq_governor cpufreq_g
  #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)
  extern struct cpufreq_governor cpufreq_gov_userspace;
  #define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_userspace
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE)
+extern struct cpufreq_governor cpufreq_gov_powersave;
+#define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_powersave
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE)
+extern struct cpufreq_governor cpufreq_gov_conservative;
+#define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_conservative
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND)
+extern struct cpufreq_governor cpufreq_gov_ondemand;
+#define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_ondemand
  #endif
