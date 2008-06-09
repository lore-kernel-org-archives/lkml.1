Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbYFIOVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbYFIOVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYFIOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbYFIOSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:47 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 08/15] x86: remove ifdef from stepping
Date: Mon,  9 Jun 2008 11:16:51 -0300
Message-Id: <1213021018-14159-9-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-8-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stepping won't affect x86_64, since there are not x86_64 k7's
or pentiums. So, although it adds to the binary size, remove the ifdef
for smoother integration

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5a055a1..50d307e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -351,7 +351,6 @@ static void __cpuinit start_secondary(void *unused)
 
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_X86_32
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
@@ -401,7 +400,6 @@ static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 
 valid_k7:
 	;
-#endif
 }
 
 static void __cpuinit smp_checks(void)
-- 
1.5.4.5

