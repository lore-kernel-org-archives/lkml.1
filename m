Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbZDWSsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbZDWSsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZDWSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:47:57 -0400
Received: from relay1.ptmail.sapo.pt ([212.55.154.21]:56964 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753702AbZDWSr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:47:57 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Thu, 23 Apr 2009 19:45:04 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Devriendt <paul.devriendt@amd.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] powernow-k8.c: mess cleanup
Message-ID: <20090423184504.GA5487@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mess cleanup in powernow_k8_acpi_pst_values() function.

Signed-off-by: Luis Henriques <henrix@sapo.pt>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 4709ead..6c31f95 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,3 +1,4 @@
+
 /*
  *   (c) 2003-2006 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
@@ -809,13 +810,14 @@ static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data,
 	if (!data->acpi_data.state_count || (cpu_family == CPU_HW_PSTATE))
 		return;
 
-	control = data->acpi_data.states[index].control; data->irt = (control
-			>> IRT_SHIFT) & IRT_MASK; data->rvo = (control >>
-				RVO_SHIFT) & RVO_MASK; data->exttype = (control
-					>> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
-	data->plllock = (control >> PLL_L_SHIFT) & PLL_L_MASK; data->vidmvs = 1
-		<< ((control >> MVS_SHIFT) & MVS_MASK); data->vstable =
-		(control >> VST_SHIFT) & VST_MASK; }
+	control = data->acpi_data.states[index].control;
+	data->irt = (control >> IRT_SHIFT) & IRT_MASK;
+	data->rvo = (control >> RVO_SHIFT) & RVO_MASK;
+	data->exttype = (control >> EXT_TYPE_SHIFT) & EXT_TYPE_MASK;
+	data->plllock = (control >> PLL_L_SHIFT) & PLL_L_MASK;
+	data->vidmvs = 1 << ((control >> MVS_SHIFT) & MVS_MASK);
+	data->vstable = (control >> VST_SHIFT) & VST_MASK;
+}
 
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 {
-- 
1.6.2.4

