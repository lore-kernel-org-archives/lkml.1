Return-Path: <linux-kernel-owner+w=401wt.eu-S935979AbYBUXuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935979AbYBUXuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935722AbYBUXsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:25 -0500
Received: from mail.suse.de ([195.135.220.2]:45010 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765143AbYBUXsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
       Yi Yang <yi.y.yang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Frans Pop <elendil@planet.nl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/11] cpufreq: fix kobject reference count handling
Date: Thu, 21 Feb 2008 15:47:59 -0800
Message-Id: <1203637687-7273-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji Rao <balajirrao@gmail.com>

The cpufreq core should not take an extra kobject reference count for no
reason, and then refuse to release it.  This has been reported as
keeping machines from properly powering down all the way.


Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Yi Yang <yi.y.yang@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Frans Pop <elendil@planet.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/cpufreq/cpufreq.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 64926aa..89a29cd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1006,14 +1006,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 	}
 #endif
 
-
-	if (!kobject_get(&data->kobj)) {
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		cpufreq_debug_enable_ratelimit();
-		unlock_policy_rwsem_write(cpu);
-		return -EFAULT;
-	}
-
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.5.4

