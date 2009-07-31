Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZGaOka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZGaOka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZGaOk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:40:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41200 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZGaOk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:40:27 -0400
From: Nicolas Palix <npalix@diku.dk>
To: x86@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix compilation error in amd.c when SMP is not set
Date: Fri, 31 Jul 2009 16:40:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311640.25585.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function amd_fixup_dcm requires SMP to be set
but it is called only when CONFIG_X86_HT is set.

It thus defined only if CONFIG_X86_HT is set.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 arch/x86/kernel/cpu/amd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e06fa7c..1c15916 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -256,6 +256,7 @@ static int __cpuinit nearby_node(int apicid)
  * Assumption 2: Mixed systems with both single-node and dual-node
  *               processors are not supported.
  */
+#ifdef CONFIG_X86_HT
 static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 {
 	u32 t, cpn;
@@ -299,6 +300,7 @@ static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 	 /* fixup core id to be in range from 0 to cpn */
 	c->cpu_core_id = c->cpu_core_id % cpn;
 }
+#endif
 
 /*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
-- 
1.6.0.4


-- 
Nicolas Palix
