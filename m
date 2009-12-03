Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbZLCPha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbZLCPha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZLCPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:37:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:33105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbZLCPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:37:25 -0500
Date: Thu, 3 Dec 2009 15:36:37 GMT
From: tip-bot for Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, andreas.herrmann3@amd.com, mikpe@it.uu.se,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, joerg.roedel@amd.com, mikpe@it.uu.se,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19223.53436.931768.278021@pilspetsen.it.uu.se>
References: <19223.53436.931768.278021@pilspetsen.it.uu.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Enable lapic nmi watchdog on AMD Family 11h
Message-ID: <tip-7d1849aff6687a135a8da3a75e32a00e3137a5e2@git.kernel.org>
Git-Commit-ID: 7d1849aff6687a135a8da3a75e32a00e3137a5e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d1849aff6687a135a8da3a75e32a00e3137a5e2
Gitweb:     http://git.kernel.org/tip/7d1849aff6687a135a8da3a75e32a00e3137a5e2
Author:     Mikael Pettersson <mikpe@it.uu.se>
AuthorDate: Thu, 3 Dec 2009 15:52:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 16:25:15 +0100

x86, apic: Enable lapic nmi watchdog on AMD Family 11h

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
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: <stable@kernel.org>
LKML-Reference: <19223.53436.931768.278021@pilspetsen.it.uu.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fab786f..898df97 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -712,7 +712,7 @@ static void probe_nmi_watchdog(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;
