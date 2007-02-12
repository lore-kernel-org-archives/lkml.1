Return-Path: <linux-kernel-owner+w=401wt.eu-S965015AbXBLQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbXBLQzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965002AbXBLQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:55:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:53629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbXBLQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:40 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [19/29] x86: Enable NMI watchdog for AMD Family 0x10 CPUs
Message-Id: <20070212165139.CAD8F13E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For i386/x86-64.

Straight forward -- just reuse the Family 0xf code.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/nmi.c   |    6 ++++--
 arch/x86_64/kernel/nmi.c |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -185,7 +185,8 @@ static __cpuinit inline int nmi_known_cp
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6));
+		return ((boot_cpu_data.x86 == 15) || (boot_cpu_data.x86 == 6)
+			|| (boot_cpu_data.x86 == 16));
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 			return 1;
@@ -817,7 +818,8 @@ void setup_apic_nmi_watchdog (void *unus
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15)
+			if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
+				boot_cpu_data.x86 != 16)
 				return;
 			if (!setup_k7_watchdog())
 				return;
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -172,7 +172,7 @@ static __cpuinit inline int nmi_known_cp
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		return boot_cpu_data.x86 == 15;
+		return boot_cpu_data.x86 == 15 || boot_cpu_data.x86 == 16;
 	case X86_VENDOR_INTEL:
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 			return 1;
