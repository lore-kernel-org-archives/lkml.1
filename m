Return-Path: <linux-kernel-owner+w=401wt.eu-S935532AbZLGRGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935532AbZLGRGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935517AbZLGRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:06:12 -0500
Received: from mga06.intel.com ([134.134.136.21]:26356 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935484AbZLGRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:06:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="576394789"
Date: Mon, 7 Dec 2009 09:06:16 -0800
From: mark gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, aili@codeaurora.org,
       e1000-devel@lists.sourceforge.net, bruce.w.allan@intel.com,
       linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
       tiwai@suse.de
Subject: [PATCH]PM_QOS-to-use-handle-based-requests-cpuidle-update 2/5
Message-ID: <20091207170616.GC5463@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: mark gross <mgross@linux.intel.com>
---
 drivers/acpi/processor_idle.c      |    2 +-
 drivers/cpuidle/governors/ladder.c |    2 +-
 drivers/cpuidle/governors/menu.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index bbd066e..1f524a2 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -696,7 +696,7 @@ static int acpi_processor_power_seq_show(struct seq_file *seq, void *offset)
 		   "max_cstate:              C%d\n"
 		   "maximum allowed latency: %d usec\n",
 		   pr->power.state ? pr->power.state - pr->power.states : 0,
-		   max_cstate, pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY));
+		   max_cstate, pm_qos_request(PM_QOS_CPU_DMA_LATENCY));
 
 	seq_puts(seq, "states:\n");
 
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index a4bec3f..5f93084 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -67,7 +67,7 @@ static int ladder_select_state(struct cpuidle_device *dev)
 	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
 	struct ladder_device_state *last_state;
 	int last_residency, last_idx = ldev->last_state_idx;
-	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
+	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 
 	if (unlikely(!ldev))
 		return 0;
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 6810443..f75aec5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -176,7 +176,7 @@ static void menu_update(struct cpuidle_device *dev);
 static int menu_select(struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
-	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
+	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
 
-- 
1.6.3.3

