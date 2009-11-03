Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZKCE2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZKCE2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZKCE2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:28:39 -0500
Received: from ozlabs.org ([203.10.76.45]:39501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbZKCE2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:28:37 -0500
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org
To: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031458.38406.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:58:38 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/14] cpumask: use modern cpumask style in Xen
Cc: x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: x86@kernel.org
---
 arch/x86/xen/smp.c        |    2 +-
 drivers/xen/cpu_hotplug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -73,7 +73,7 @@ static __cpuinit void cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	percpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -86,7 +86,7 @@ static int setup_cpu_watcher(struct noti
 	for_each_possible_cpu(cpu) {
 		if (vcpu_online(cpu) == 0) {
 			(void)cpu_down(cpu);
-			cpu_clear(cpu, cpu_present_map);
+			set_cpu_present(cpu, false);
 		}
 	}
 

