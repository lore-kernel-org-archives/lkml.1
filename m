Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbXGHL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbXGHL7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXGHLzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:22 -0400
Received: from il.qumranet.com ([82.166.9.18]:38397 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbXGHLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 15/20] HOTPLUG: Adapt cpuset hotplug callback to CPU_DYING
Date: Sun,  8 Jul 2007 14:54:44 +0300
Message-Id: <1183895689671-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_DYING is called in atomic context, so don't try to take any locks.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 kernel/cpuset.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4c49188..c4d123f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2138,6 +2138,9 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *nb,
 				unsigned long phase, void *cpu)
 {
+	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+		return NOTIFY_DONE;
+
 	common_cpu_mem_hotplug_unplug();
 	return 0;
 }
-- 
1.5.2.2

