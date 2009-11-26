Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZKZJ4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZKZJ4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZKZJ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:59945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZKZJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:15 -0500
Date: Thu, 26 Nov 2009 09:55:43 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B0E3C4E.4090809@jp.fujitsu.com>
References: <4B0E3C4E.4090809@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86, mce: Add __cpuinit to hotplug callback functions
Message-ID: <tip-767df1bdd8cbff2c8c40c9ac8295bbdaa5fb24c4@git.kernel.org>
Git-Commit-ID: 767df1bdd8cbff2c8c40c9ac8295bbdaa5fb24c4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  767df1bdd8cbff2c8c40c9ac8295bbdaa5fb24c4
Gitweb:     http://git.kernel.org/tip/767df1bdd8cbff2c8c40c9ac8295bbdaa5fb24c4
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 17:29:02 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:29:41 +0100

x86, mce: Add __cpuinit to hotplug callback functions

The mce_disable_cpu() and mce_reenable_cpu() are called only
from mce_cpu_callback() which is marked as __cpuinit.
So these functions can be __cpuinit too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <4B0E3C4E.4090809@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5f277ca..0bcaa38 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1953,13 +1953,14 @@ static __cpuinit void mce_remove_device(unsigned int cpu)
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
-static void mce_disable_cpu(void *h)
+static void __cpuinit mce_disable_cpu(void *h)
 {
 	unsigned long action = *(unsigned long *)h;
 	int i;
 
 	if (!mce_available(&current_cpu_data))
 		return;
+
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
 	for (i = 0; i < banks; i++) {
@@ -1970,7 +1971,7 @@ static void mce_disable_cpu(void *h)
 	}
 }
 
-static void mce_reenable_cpu(void *h)
+static void __cpuinit mce_reenable_cpu(void *h)
 {
 	unsigned long action = *(unsigned long *)h;
 	int i;
