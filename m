Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYIPP7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYIPP7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbYIPP7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:59:22 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:52885 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbYIPP7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:59:21 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems support it.
Date: Tue, 16 Sep 2008 11:59:15 -0400
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161159.15870.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sanders <linux@sandersweb.net>

Currently in alternative.c NOPLs are introduced based on the synthetic
cpu feature X86_FEATURE_NOPL.  However, some systems (like Virtual PC 2007)
appear to support it but then will not boot 50% of the time because of
the NOPLs (when paravirtualization support is built into kernel).
This patch standardizes the treatment of NOPL to be like
include/asm-x86/nops.h which only uses NOPLs on 64-bit processors.

Applies to 2.6.27-rc6.

Signed-off-by: David Sanders <linux@sandersweb.net>
---
 arch/x86/kernel/alternative.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 65a0c1b..dceb843 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -160,8 +160,12 @@ const unsigned char *const *find_nop_table(void)
 		return k8_nops;
 	else if (boot_cpu_has(X86_FEATURE_K7))
 		return k7_nops;
-	else if (boot_cpu_has(X86_FEATURE_NOPL))
-		return p6_nops;
+	/*
+	 * Don't use NOPL in 32-bit mode because some Emulators
+	 * do not support it.
+	 */
+	/* else if (boot_cpu_has(X86_FEATURE_NOPL))
+		return p6_nops; */
 	else
 		return intel_nops;
 }
--
1.6.0.2.229.g1293c
