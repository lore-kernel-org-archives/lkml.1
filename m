Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbYHWNC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbYHWNC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYHWNBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:01:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:20941 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbYHWNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GnbH+Wtxi0HqBFHmmWttdhcYTuk32opWH7t6o0C4lu1JjXt+mQJJjUAsyqoMTANXXq
         AA9+j94V0316fBzI6cc/dr2LsHOuG2EmLheVsd0W1Ezrn6kCzpkc3sy1ImB1j9v/JdWF
         4yIgIs/I6b3pI+6TEEbEbrRWfrfKfiWotTQ6M=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: yhlu.kernel@gmail.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 7/8] x86: apic_32.c should use __cpuinit section
Date: Sat, 23 Aug 2008 17:01:24 +0400
Message-Id: <50e67abc105166e614f5aff2a34ca73673b4a492.1219491572.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.6.gc667
In-Reply-To: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
References: <1219496485-9513-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
References: <a02f3dc9088b9b6c0d22fa77839fdd9d5309ec97.1219491572.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers are __init or __cpuinit so there is no need
to hold this code without CPU_HOTPLUG being set.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 5340295..0c608ac 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -383,7 +383,7 @@ static void lapic_timer_broadcast(cpumask_t mask)
  * Setup the local APIC timer for this CPU. Copy the initilized values
  * of the boot CPU and register the clock event in the framework.
  */
-static void __devinit setup_APIC_timer(void)
+static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
@@ -652,7 +652,7 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __devinit setup_secondary_APIC_clock(void)
+void __cpuinit setup_secondary_APIC_clock(void)
 {
 	setup_APIC_timer();
 }
@@ -1732,7 +1732,7 @@ static struct sys_device device_lapic = {
 	.cls	= &lapic_sysclass,
 };
 
-static void __devinit apic_pm_activate(void)
+static void __cpuinit apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
 }
-- 
1.6.0.6.gc667

