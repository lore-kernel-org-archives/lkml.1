Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYHXJEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYHXJEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYHXJDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYHXJDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rw4QYdACt6ImcZPi4a+huVl89eJ5MoC0T7pDG36U27eOve69pwEVgQ4IO1EGqyVCYT
         TUgBerFUJi5VnSQoTksL3Zp3n0LeTMgKwleEj12sSy3gPwdqi+NAH7wRwyKu6gddLypR
         ZnBNB5tVYQDyi8emqW9Ly8SSEJlZ+iou36W0o=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 06/18] x86: apic_32.c should use __cpuinit section
Date: Sun, 24 Aug 2008 02:01:44 -0700
Message-Id: <1219568516-681-7-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

All callers are __init or __cpuinit so there is no need
to hold this code without CPU_HOTPLUG being set.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 42acb3a..63bebb3 100644
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
@@ -1713,7 +1713,7 @@ static struct sys_device device_lapic = {
 	.cls	= &lapic_sysclass,
 };
 
-static void __devinit apic_pm_activate(void)
+static void __cpuinit apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
 }
-- 
1.5.4.5

