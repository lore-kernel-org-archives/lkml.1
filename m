Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZDSIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZDSIbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZDSIbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:31:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:60588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZDSIbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:31:21 -0400
Date: Sun, 19 Apr 2009 08:30:38 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, yhlu.kernel@gmail.com, tglx@linutronix.de,
       xemul@openvz.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yhlu.kernel@gmail.com, tglx@linutronix.de,
       xemul@openvz.org, mingo@elte.hu
In-Reply-To: <20090419074311.GA8670@lenovo>
References: <20090419074311.GA8670@lenovo>
Subject: [tip:x86/apic] x86: es7000, uv - use __cpuinit for kicking secondary cpus
Message-ID: <tip-667c5296cc76fefe0abcb79228952b28d9af45e3@git.kernel.org>
Git-Commit-ID: 667c5296cc76fefe0abcb79228952b28d9af45e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 08:30:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  667c5296cc76fefe0abcb79228952b28d9af45e3
Gitweb:     http://git.kernel.org/tip/667c5296cc76fefe0abcb79228952b28d9af45e3
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 19 Apr 2009 11:43:11 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Apr 2009 10:28:53 +0200

x86: es7000, uv - use __cpuinit for kicking secondary cpus

The caller already has __cpuinit attribute.

[ Impact: save memory, address section mismatch warning ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
LKML-Reference: <20090419074311.GA8670@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/es7000_32.c   |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 1c11b81..8e07c14 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -145,7 +145,7 @@ es7000_rename_gsi(int ioapic, int gsi)
 	return gsi;
 }
 
-static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
+static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index de1a50a..873bf71 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -91,7 +91,7 @@ static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
 	cpumask_set_cpu(cpu, retmask);
 }
 
-static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 #ifdef CONFIG_SMP
 	unsigned long val;
