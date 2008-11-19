Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYKSWDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYKSWDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKSWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:03:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:38290 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYKSWD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QmIMZ5oDAimz1T6SGndyelSlYITJ9YCoBLuE6aMhX1o7P77k3+qyRYGvFCM3NeGvdt
         mNb4ZG2ucNleZnrcFB78isHMKM7wx3kG2P0v61NzWh50Oiiq47zFlHZ7GPbcfijwYmby
         7vaFKdHauRmdAS9wFlZIr9XuYDOGC/i/pgRo8=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Fix arch/x86/kernel/genx2apic_uv_x.c build warning when !CONFIG_HOTPLUG_CPU
Date: Wed, 19 Nov 2008 16:05:14 -0700
Message-Id: <1227135915-32628-1-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix
arch/x86/kernel/genx2apic_uv_x.c:403: warning: 'uv_heartbeat_disable' defined but not used

the function is only used when CONFIG_HOTPLUG_CPU is defined.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index fb80b17..3076bc6 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -399,6 +399,7 @@ static void __cpuinit uv_heartbeat_enable(int cpu)
 		uv_heartbeat_enable(0);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
 static void __cpuinit uv_heartbeat_disable(int cpu)
 {
 	if (uv_cpu_hub_info(cpu)->scir.enabled) {
@@ -408,7 +409,6 @@ static void __cpuinit uv_heartbeat_disable(int cpu)
 	uv_set_cpu_scir_bits(cpu, 0xff);
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 /*
  * cpu hotplug notifier
  */
-- 
1.5.6.4

