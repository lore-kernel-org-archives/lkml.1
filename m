Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXGQHvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXGQHvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbXGQHtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50994 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbXGQHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] alpha __init fixes
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <E1IAhoN-0001iu-Ua@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


__init and __initdata stuff used from __devinit one

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/smp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 80cfb75..b287314 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -65,7 +65,7 @@ enum ipi_message_type {
 };
 
 /* Set to a secondary's cpuid when it comes online.  */
-static int smp_secondary_alive __initdata = 0;
+static int smp_secondary_alive __devinitdata = 0;
 
 /* Which cpus ids came online.  */
 cpumask_t cpu_online_map;
@@ -173,7 +173,7 @@ smp_callin(void)
 }
 
 /* Wait until hwrpb->txrdy is clear for cpu.  Return -1 on timeout.  */
-static int __init
+static int __devinit
 wait_for_txrdy (unsigned long cpumask)
 {
 	unsigned long timeout;
@@ -358,7 +358,7 @@ secondary_cpu_start(int cpuid, struct task_struct *idle)
 /*
  * Bring one cpu online.
  */
-static int __init
+static int __devinit
 smp_boot_one_cpu(int cpuid)
 {
 	struct task_struct *idle;
-- 
1.5.3.GIT


