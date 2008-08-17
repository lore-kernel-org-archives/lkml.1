Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYHQTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYHQTlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYHQTlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYHQTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JWCtyWUF59bX8lTg6b3dOnVKtdqkZ2JsVydI6+DVi3iYple2HJfO+1gjFroOkivuwC
         ntobEunLAeS9ymoUd8ZsD3klUh6wHuFcXecxZapBgc7DOQUfux78zdz//eVmLn7aYOv0
         D3YuuTeUm19QZB/ST2mqAfv3ubU+Q2cCaNqyA=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/9] x86: apic - rearrange maxcpu definition
Date: Sun, 17 Aug 2008 23:41:39 +0400
Message-Id: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    4 ++--
 arch/x86/kernel/apic_64.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 41134d4..8d1febf 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -114,6 +114,8 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 static int enabled_via_apicbase;
 
 static unsigned long apic_phys;
+unsigned int __cpuinitdata maxcpus = NR_CPUS;
+
 
 /*
  * Get the LAPIC version
@@ -1459,8 +1461,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	}
 }
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
-
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5e07381..6aa0f60 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -98,10 +98,10 @@ static struct clock_event_device lapic_clockevent = {
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
 static unsigned long apic_phys;
+unsigned int __cpuinitdata maxcpus = NR_CPUS;
 
 unsigned long mp_lapic_addr;
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
  */
-- 
1.6.0.rc1.34.g0fe8c

