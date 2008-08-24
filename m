Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYHXJD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYHXJD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYHXJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:02:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYHXJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:02:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qaNZGVTo9IdIZwBUK4BL2X4Hvp0Kcd/a4rlnTXsHESIik4x8M7dXM+Z9ttu1d9K6mq
         gC41bq5wKB6+32ygigt5VRuJf2IMoKqpUSAer1m0gyWri9+fAx2SU2iP8PSiaL8u9k9i
         a1bqAHW7GyA+WLpaIUbMiYWkfDmTQtNi6a++8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 01/18] x86: apic_64.c - setup_APIC_timer has to be __cpuinit function
Date: Sun, 24 Aug 2008 02:01:39 -0700
Message-Id: <1219568516-681-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

There is no need to hold this code if CPU_HOTPLUG is not
defined

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index cd86085..8f55127 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -400,7 +400,7 @@ static void lapic_timer_broadcast(cpumask_t mask)
  * Setup the local APIC timer for this CPU. Copy the initilized values
  * of the boot CPU and register the clock event in the framework.
  */
-static void setup_APIC_timer(void)
+static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-- 
1.5.4.5

