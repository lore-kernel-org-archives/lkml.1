Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbXBLHlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbXBLHlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933119AbXBLHkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:40:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:38434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774AbXBLHib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:31 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [39/39] i386: All Transmeta CPUs have constant TSCs
Message-Id: <20070212073827.DC1A813DFC@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "H. Peter Anvin" <hpa@zytor.com>

All Transmeta CPUs ever produced have constant-rate TSCs.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/transmeta.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/arch/i386/kernel/cpu/transmeta.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/transmeta.c
+++ linux/arch/i386/kernel/cpu/transmeta.c
@@ -72,6 +72,9 @@ static void __cpuinit init_transmeta(str
 	wrmsr(0x80860004, ~0, uk);
 	c->x86_capability[0] = cpuid_edx(0x00000001);
 	wrmsr(0x80860004, cap_mask, uk);
+
+	/* All Transmeta CPUs have a constant TSC */
+	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
 	
 	/* If we can run i686 user-space code, call us an i686 */
 #define USER686 (X86_FEATURE_TSC|X86_FEATURE_CX8|X86_FEATURE_CMOV)
