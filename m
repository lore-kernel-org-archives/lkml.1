Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbZDINFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbZDINFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbZDINF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:05:27 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:22564 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414AbZDINF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:05:26 -0400
X-BigFish: VPS-17(z34a4jz9370P936eQ936fKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KHU4CJ-01-LGG-01
Date: Thu, 9 Apr 2009 15:05:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH 3/8] x86: cacheinfo: use L3 cache index disable feature
	only for CPUs that support it
Message-ID: <20090409130510.GG31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:05:11.0515 (UTC) FILETIME=[D0C972B0:01C9B913]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD family 0x11 CPU doesn't support the feature.

Some AMD family 0x10 CPUs do not support it or have an erratum, see
erratum #382 in "Revision Guide for AMD Family 10h Processors, 41322
Rev. 3.40 February 2009".

CC: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c471eb1..3973506 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -291,6 +291,14 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	if (index < 3)
 		return;
+
+	if (boot_cpu_data.x86 == 0x11)
+		return;
+
+	/* see erratum #382 */
+	if ((boot_cpu_data.x86 == 0x10) && (boot_cpu_data.x86_model < 0x8))
+		return;
+
 	this_leaf->can_disable = 1;
 }
 
-- 
1.6.2



