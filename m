Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZKDP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZKDP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZKDP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:27:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:57414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbZKDP1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:27:15 -0500
Date: Wed, 4 Nov 2009 15:26:52 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, jeremy@xensource.com, hpa@zytor.com,
       mingo@redhat.com, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@xensource.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200911031458.38406.rusty@rustcorp.com.au>
References: <200911031458.38406.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xen] cpumask: Use modern cpumask style in Xen
Message-ID: <tip-d7d3756c5b1277fafd132ce7a2211b388c3b5bd2@git.kernel.org>
Git-Commit-ID: d7d3756c5b1277fafd132ce7a2211b388c3b5bd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7d3756c5b1277fafd132ce7a2211b388c3b5bd2
Gitweb:     http://git.kernel.org/tip/d7d3756c5b1277fafd132ce7a2211b388c3b5bd2
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 3 Nov 2009 14:58:38 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:19:50 +0100

cpumask: Use modern cpumask style in Xen

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
LKML-Reference: <200911031458.38406.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/smp.c        |    2 +-
 drivers/xen/cpu_hotplug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index fe03eee..738da0c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -73,7 +73,7 @@ static __cpuinit void cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	percpu_write(cpu_state, CPU_ONLINE);
 	wmb();
 
diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index bdfd584..0f765a9 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -86,7 +86,7 @@ static int setup_cpu_watcher(struct notifier_block *notifier,
 	for_each_possible_cpu(cpu) {
 		if (vcpu_online(cpu) == 0) {
 			(void)cpu_down(cpu);
-			cpu_clear(cpu, cpu_present_map);
+			set_cpu_present(cpu, false);
 		}
 	}
 
