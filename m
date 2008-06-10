Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYFJOay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYFJOay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYFJOap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:30:45 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:22290 "EHLO
	mail17-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYFJOao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:30:44 -0400
X-Greylist: delayed 1559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 10:30:44 EDT
X-BigFish: VPS2(zzzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2933A-01-IN0-01
Date: Tue, 10 Jun 2008 16:04:30 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86: unconditionally enable PAT for AMD CPUs
Message-ID: <20080610140430.GE5024@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jun 2008 14:04:25.0016 (UTC) FILETIME=[E3AC6B80:01C8CB02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If PAT support is advertised it should just work. No errata known.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index d8b3e4a..0fbd062 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -54,14 +54,11 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			return;
-		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
 			return;
 		break;
+	case X86_VENDOR_AMD:
 	case X86_VENDOR_CENTAUR:
 	case X86_VENDOR_TRANSMETA:
 		return;
-- 
1.5.5.3



