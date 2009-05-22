Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZEVJnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZEVJnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZEVJmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:42:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23009 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbZEVJmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:42:54 -0400
X-IronPort-AV: E=Sophos;i="4.41,232,1241409600"; 
   d="scan'208";a="4393669"
Subject: [PATCH] perf_counter: do not create perf counter mlock sysctl when
	CONFIG_PERF_COUNTERS=n
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 10:42:53 +0100
Message-ID: <1242985373.22654.225.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building tip from 82811bee3 without CONFIG_PERF_COUNTERS results in:

  CC      kernel/sysctl.o
kernel/sysctl.c:928: error: 'sysctl_perf_counter_mlock' undeclared here (not in a function)

This is due to c5078f78b "perf_counter: provide an mlock threshold"

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 44ebd90..c2a4467 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -922,6 +922,7 @@ static struct ctl_table kern_table[] = {
 		.child		= slow_work_sysctls,
 	},
 #endif
+#ifdef CONFIG_PERF_COUNTERS
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "perf_counter_mlock_kb",
@@ -930,6 +931,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt


