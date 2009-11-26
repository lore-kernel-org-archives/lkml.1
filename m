Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbZKZI3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbZKZI3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759604AbZKZI3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:29:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597AbZKZI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:29:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0E3C4E.4090809@jp.fujitsu.com>
Date: Thu, 26 Nov 2009 17:29:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86, mce: add __cpuinit to hotplug callback functions
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mce_disable_cpu() and mce_reenable_cpu() are called only from
mce_cpu_callback() which is marked as __cpuinit.
So these functions can be __cpuinit too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8627976..ea8ca56 100644
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
-- 
1.6.5.3

