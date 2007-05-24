Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXEXMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXEXMK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXEXMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:36436 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbXEXMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:18 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 2/7] HOTPLUG: Adapt cpuset hotplug callback to CPU_DYING
Date: Thu, 24 May 2007 15:10:10 +0300
Message-Id: <11800086153720-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_DYING is called in atomic context, so don't try to take any locks.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 kernel/cpuset.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f57854b..d4ab1c6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2138,6 +2138,9 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *nb,
 				unsigned long phase, void *cpu)
 {
+	if (phase == CPU_DYING)
+		return NOTIFY_DONE;
+
 	common_cpu_mem_hotplug_unplug();
 	return 0;
 }
-- 
1.5.0.6

