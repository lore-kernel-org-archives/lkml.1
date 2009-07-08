Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZGHTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZGHTYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZGHTYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:24:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36498 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZGHTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:24:39 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, rjw@sisk.pl,
       mingo@elte.hu, Shaohua Li <shaohua.li@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Young <hidave.darkstar@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, sven.wegener@stealer.net,
       cpufreq@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Dave Jones <davej@redhat.com>
Subject: [PATCH] cpufreq: unbreak build for !CONFIG_SMP
Date: Wed,  8 Jul 2009 21:24:27 +0200
Message-Id: <1247081067-21964-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'managed_policy' is used for the non-smp case in line 941.

Remove #ifdef CONFIG_SMP for its declaration in order to make cpufreq.c
build on systems with CONFIG_SMP=n.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: rjw@sisk.pl
Cc: mingo@elte.hu
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: sven.wegener@stealer.net
Cc: cpufreq@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>
---
 drivers/cpufreq/cpufreq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c668ac8..d160867 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -776,9 +776,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	struct sys_device *cpu_sys_dev;
 	unsigned long flags;
 	unsigned int j;
-#ifdef CONFIG_SMP
 	struct cpufreq_policy *managed_policy;
-#endif
 
 	if (cpu_is_offline(cpu))
 		return 0;
-- 
1.6.3.1

