Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbZA2AGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbZA2AGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZA1Xpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685AbZA1Xp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:28 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 053/114] x86, mpparse: call the generic quirk handlers early
Date: Wed, 28 Jan 2009 23:41:59 +0000
Message-Id: <1233186180-29883-54-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call all the registered MPS quirk handlers early. These methods scan
low RAM typically for specific signatures so are safe to be called
early.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/mpparse.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c8a534a..f6fb192 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -292,16 +292,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		return 0;
 
 #ifdef CONFIG_X86_32
-	/*
-	 * need to make sure summit and es7000's mps_oem_check is safe to be
-	 * called early via genericarch 's mps_oem_check
-	 */
-	if (early) {
-#ifdef CONFIG_X86_NUMAQ
-		numaq_mps_oem_check(mpc, oem, str);
-#endif
-	} else
-		mps_oem_check(mpc, oem, str);
+	mps_oem_check(mpc, oem, str);
 #endif
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
-- 
1.6.0.2

