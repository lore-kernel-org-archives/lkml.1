Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbZA1XqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbZA1XqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbZA1Xnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:37367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070AbZA1Xnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:31 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 006/114] x86, genapic: provide IPI callbacks unconditionally
Date: Wed, 28 Jan 2009 23:41:12 +0000
Message-Id: <1233186180-29883-7-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit x86 uses the IPI callbacks even on UP - so provide them
generally.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 19a5193..c27efde 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -73,7 +73,6 @@ struct genapic {
 	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
 					       const struct cpumask *andmask);
 
-#ifdef CONFIG_SMP
 	/* ipi */
 	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
 	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
@@ -81,7 +80,7 @@ struct genapic {
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
-#endif
+
 	/* wakeup_secondary_cpu */
 	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
 
-- 
1.6.0.2

