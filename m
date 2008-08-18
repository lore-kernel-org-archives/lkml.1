Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYHRQrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYHRQrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbYHRQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbYHRQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JWjff5wOGlCmuRZ3ncve62dr3/PydP0QAh0FoDYCM6fL1wv/GP2p5z40+7RXth7B+C
         OjfYTKWMU88xFmExOOm5PA6cA9pWxo79N32PxRFKckfcW2217KWEtAYv3jG4AHTExEz5
         PmnBYqGZwUV1buF1KqTGPIj3CQOYKcrapiny8=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 01/15] x86: apic - rearrange maxcpu definition
Date: Mon, 18 Aug 2008 20:45:49 +0400
Message-Id: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
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
index ad532dc..46acb9b 100644
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

