Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZFHKaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZFHKaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFHK3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:29:55 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46190 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZFHK3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:29:54 -0400
Date: Mon, 8 Jun 2009 18:27:54 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 1/2] CPUFREQ: Enable acpi-cpufreq driver for VIA/Centaur
	CPUs
Message-ID: <20090608102754.GP4106@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906060856.15016.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VIA/Centaur C7, C7-M and Nano CPU's all support ACPI based cpu p-states
using a MSR interface.  The Linux driver just never made use of it, since in
addition to the check for the EST flag it also checked if the vendor is Intel.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 208ecf6..ee03585 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -90,7 +90,8 @@ static int check_est_cpu(unsigned int cpuid)
 {
 	struct cpuinfo_x86 *cpu = &cpu_data(cpuid);
 
-	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
+	if ((cpu->x86_vendor != X86_VENDOR_INTEL &&
+	     cpu->x86_vendor != X86_VENDOR_CENTAUR) ||
 	    !cpu_has(cpu, X86_FEATURE_EST))
 		return 0;
 
-- 
1.6.2.4

