Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXHWCUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXHWCUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXHWCUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:20:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbXHWCUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:20:39 -0400
Date: Thu, 23 Aug 2007 08:03:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Dave Jones <davej@codemonkey.org.uk>
cc: Ashok Raj <ashok.raj@intel.com>, Jacob Shin <jacob.shin@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Mark hotplug notifier callback as __cpuinit
Message-ID: <alpine.LFD.0.999.0708230759540.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The notifier_block is already __cpuinitdata, thereby allowing us to
safely mark the callback function as __cpuinit also, thereby saving
space when HOTPLUG_CPU=n.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/cpufreq/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2f6a73c..a86b71a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1703,7 +1703,7 @@ int cpufreq_update_policy(unsigned int cpu)
 }
 EXPORT_SYMBOL(cpufreq_update_policy);
 
-static int cpufreq_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
