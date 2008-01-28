Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbYA1Edl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbYA1Edl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYA1Ed3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:33:29 -0500
Received: from warlock.qualcomm.com ([129.46.50.49]:41107 "EHLO
	warlock.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYA1Ed2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:33:28 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 23:33:28 EST
From: maxk@qualcomm.com
To: linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] [CPUISOL] Do not route IRQs to the CPUs isolated at boot
Date: Sun, 27 Jan 2008 20:09:40 -0800
Message-Id: <1201493382-29804-4-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201493382-29804-3-git-send-email-maxk@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-2-git-send-email-maxk@qualcomm.com>
 <1201493382-29804-3-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>

Most people would expect isolated CPUs to not get any
IRQs by default. This happens naturally if CPU is brought
off-line, marked isolated and then brought back online.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
---
 arch/x86/kernel/genapic_flat_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 07352b7..e02e58c 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -21,7 +21,9 @@
 
 static cpumask_t flat_target_cpus(void)
 {
-	return cpu_online_map;
+	cpumask_t target;
+	cpus_andnot(target, cpu_online_map, cpu_isolated_map);
+	return target;
 }
 
 static cpumask_t flat_vector_allocation_domain(int cpu)
-- 
1.5.3.7

