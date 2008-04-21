Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYDUIvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYDUIvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYDUIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:50:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58428 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265AbYDUIuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:50:20 -0400
Date: Mon, 21 Apr 2008 11:49:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make lapic_setup_esr() static
Message-ID: <20080421084951.GX26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global lapic_setup_esr() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/apic_32.c |    2 +-
 arch/x86/kernel/apic_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

b26ed10132e454649341363a620ab7bf3d6e7553 diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6872081..8317401 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -902,7 +902,7 @@ void __init init_bsp_APIC(void)
 	apic_write_around(APIC_LVT1, value);
 }
 
-void __cpuinit lapic_setup_esr(void)
+static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9e8e5c0..7a65b94 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -834,7 +834,7 @@ void __cpuinit setup_local_APIC(void)
 	preempt_enable();
 }
 
-void __cpuinit lapic_setup_esr(void)
+static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned maxlvt = lapic_get_maxlvt();
 

