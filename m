Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZKQTSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZKQTSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:18:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZKQTR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:17:59 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756209AbZKQTR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:17:57 -0500
Message-Id: <20091117191801.252881000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 13:17:56 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] sched: Limit the number of scheduler debug messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=limit_sched_debug_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the verbose scheduler debug messages unless kernel parameter
"sched_debug" set.  /proc/sched_debug unchanged.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/sched.c                      |   13 +++++++++++++
 2 files changed, 15 insertions(+)

--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -2182,6 +2182,8 @@
 
 	sbni=		[NET] Granch SBNI12 leased line adapter
 
+	sched_debug	[KNL] Enables verbose scheduler debug messages.
+
 	sc1200wdt=	[HW,WDT] SC1200 WDT (watchdog) driver
 			Format: <io>[,<timeout>[,<isapnp>]]
 
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -7743,6 +7743,16 @@
 
 #ifdef CONFIG_SCHED_DEBUG
 
+static __read_mostly int sched_domain_debug_enabled;
+
+static int __init sched_domain_debug_setup(char *str)
+{
+	sched_domain_debug_enabled = 1;
+
+	return 0;
+}
+early_param("sched_debug", sched_domain_debug_setup);
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
@@ -7829,6 +7839,9 @@
 	cpumask_var_t groupmask;
 	int level = 0;
 
+	if (!sched_domain_debug_enabled)
+		return;
+
 	if (!sd) {
 		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
 		return;

