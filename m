Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYBGTDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYBGTDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYBGTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:02:56 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:57613 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbYBGTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:02:54 -0500
Date: Thu, 7 Feb 2008 20:02:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, davej@codemonkey.org.uk, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080207190241.GA9449@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 07 Feb 2008 18:56:22.0376 (UTC) FILETIME=[219C6E80:01C869BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[probably stable material too]

Use global TLB flushes in MTRR code

Obviously kernel mappings should be flushed here too.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux/arch/x86/kernel/cpu/mtrr/generic.c
@@ -356,7 +356,7 @@ static void prepare_set(void) __acquires
 	}
 
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
-	__flush_tlb();
+	__flush_tlb_all();
 
 	/*  Save MTRR state */
 	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
@@ -368,7 +368,7 @@ static void prepare_set(void) __acquires
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/*  Flush TLBs (no need to flush caches - they are disabled)  */
-	__flush_tlb();
+	__flush_tlb_all();
 
 	/* Intel (P6) standard MTRRs */
 	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
