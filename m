Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXLKWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXLKWZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbXLKWWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:50 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38525 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756832AbXLKWWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:47 -0500
Date: Tue, 11 Dec 2007 23:22:48 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 apic_32.c section fix
Message-ID: <20071211222248.GS14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x2390d): Section mismatch: reference to .init.text.5:setup_local_APIC (between 'start_secondary' and 'check_tsc_warp')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ffa2f7f7e1cb68073b9ad597414dfd792ab5c697 
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 96986b4..edb5108 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -849,7 +849,7 @@ void __init init_bsp_APIC(void)
 /**
  * setup_local_APIC - setup the local APIC
  */
-void __devinit setup_local_APIC(void)
+void __cpuinit setup_local_APIC(void)
 {
 	unsigned long oldvalue, value, maxlvt, integrated;
 	int i, j;

