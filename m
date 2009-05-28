Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbZE1ABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbZE1ABU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbZE1ABM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:01:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZE1ABK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:01:10 -0400
Date: Thu, 28 May 2009 00:00:31 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A13B344.7030307@kernel.org>
References: <4A13B344.7030307@kernel.org>
Subject: [tip:irq/numa] x86: enable_update_mptable should be a macro
Message-ID: <tip-abfe0af9813153bae8c85d9bac966bafcb8ddab1@git.kernel.org>
Git-Commit-ID: abfe0af9813153bae8c85d9bac966bafcb8ddab1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 00:00:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abfe0af9813153bae8c85d9bac966bafcb8ddab1
Gitweb:     http://git.kernel.org/tip/abfe0af9813153bae8c85d9bac966bafcb8ddab1
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 20 May 2009 00:37:40 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 May 2009 01:59:05 +0200

x86: enable_update_mptable should be a macro

instead of declaring one variant as an inline function...
because other case is a variable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4A13B344.7030307@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/mpspec.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3dcbaaa..e2a1bb6 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -61,9 +61,11 @@ extern void get_smp_config(void);
 #ifdef CONFIG_X86_MPPARSE
 extern void find_smp_config(void);
 extern void early_reserve_e820_mpc_new(void);
+extern int enable_update_mptable;
 #else
 static inline void find_smp_config(void) { }
 static inline void early_reserve_e820_mpc_new(void) { }
+#define enable_update_mptable 0
 #endif
 
 void __cpuinit generic_processor_info(int apicid, int version);
@@ -87,15 +89,6 @@ static inline int acpi_probe_gsi(void)
 }
 #endif /* CONFIG_ACPI */
 
-#ifdef CONFIG_X86_MPPARSE
-extern int enable_update_mptable;
-#else
-static inline int enable_update_mptable(void)
-{
-	return 0;
-}
-#endif
-
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
 struct physid_mask {
