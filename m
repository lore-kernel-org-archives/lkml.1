Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXBTAHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXBTAHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXBTAHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:05 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36049 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750945AbXBTAG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:06:59 -0500
Date: Tue, 20 Feb 2007 01:06:58 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spyro@f2s.com
Subject: [2.6 patch] arch/arm26/kernel/entry.S: remove dead code
Message-ID: <20070220000658.GL13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_ALIGNMENT_TRAP is never set on arm26.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Ian Molton <spyro@f2s.com>

---

This patch was already sent on:
- 18 Jan 2007

 arch/arm26/kernel/entry.S |   10 ----------
 1 file changed, 10 deletions(-)

--- linux-2.6.20-rc4-mm1/arch/arm26/kernel/entry.S.old	2007-01-18 22:08:51.000000000 +0100
+++ linux-2.6.20-rc4-mm1/arch/arm26/kernel/entry.S	2007-01-18 22:09:12.000000000 +0100
@@ -245,11 +245,6 @@
 	zero_fp
 	get_scno
 
-#ifdef CONFIG_ALIGNMENT_TRAP
-	ldr	ip, __cr_alignment
-	ldr	ip, [ip]
-	mcr	p15, 0, ip, c1, c0		@ update control register
-#endif
 	enable_irqs ip
 
 	str	r4, [sp, #-S_OFF]!		@ push fifth arg
@@ -299,11 +294,6 @@
 	b	ret_slow_syscall
 
 	.align	5
-#ifdef CONFIG_ALIGNMENT_TRAP
-	.type	__cr_alignment, #object
-__cr_alignment:
-	.word	cr_alignment
-#endif
 
 	.type	sys_call_table, #object
 ENTRY(sys_call_table)

k
