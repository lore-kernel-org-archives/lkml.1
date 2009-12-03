Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZLCOwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZLCOwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLCOwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:52:46 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:58752 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbZLCOwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:52:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19223.53436.931768.278021@pilspetsen.it.uu.se>
Date: Thu, 3 Dec 2009 15:52:44 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: x86@kernel.org
Subject: [PATCH 2.6.32] x86: enable lapic nmi watchdog on AMD Family 11h
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 lapic nmi watchdog does not recognize AMD Family 11h,
resulting in:

NMI watchdog: CPU not supported

As far as I can see from available documentation (the BKDM),
family 11h looks identical to family 10h as far as the PMU
is concerned.

Extending the check to accept family 11h results in:

Testing NMI watchdog ... OK.

I've been running with this change on a Turion X2 Ultra ZM-82
laptop for a couple of weeks now without problems.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---

diff -rupN linux-2.6.32/arch/x86/kernel/cpu/perfctr-watchdog.c linux-2.6.32.x86-amd-fam11-nmi/arch/x86/kernel/cpu/perfctr-watchdog.c
--- linux-2.6.32/arch/x86/kernel/cpu/perfctr-watchdog.c	2009-12-03 12:38:32.000000000 +0100
+++ linux-2.6.32.x86-amd-fam11-nmi/arch/x86/kernel/cpu/perfctr-watchdog.c	2009-12-03 12:47:59.000000000 +0100
@@ -712,7 +712,7 @@ static void probe_nmi_watchdog(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;
