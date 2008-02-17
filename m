Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYBQSRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYBQSRm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYBQSRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:17:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57335 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbYBQSR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:17:28 -0500
Date: Sun, 17 Feb 2008 19:17:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 cleanup: suspend_asm_64.S - use X86_CR4_PGE
	instead of numeric value
Message-ID: <20080217181716.GY6006@elte.hu>
References: <20080208214913.GB6787@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208214913.GB6787@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> By including <asm/processor-flags.h> we're allowed to use X86_CR4_PGE 
> instead of numeric constant.
> 
> md5 sums of compiled files are differ due to this inclusion but .text 
> section remains the same.

thanks Cyrill, picked it up. (the merged version is below - the target 
files moved meanwhile)

	Ingo

------------->
Subject: x86 cleanup: suspend_asm_64.S - use X86_CR4_PGE instead of numeric value
From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Sat, 9 Feb 2008 00:49:13 +0300

By including <asm/processor-flags.h> we're allowed to use
X86_CR4_PGE instead of numeric constant.

md5 sums of compiled files are differ due to this inclusion
but .text section remains the same.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/power/hibernate_asm_64.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/power/hibernate_asm_64.S
===================================================================
--- linux-x86.q.orig/arch/x86/power/hibernate_asm_64.S
+++ linux-x86.q/arch/x86/power/hibernate_asm_64.S
@@ -20,6 +20,7 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
 
 ENTRY(swsusp_arch_suspend)
 	movq	$saved_context, %rax
@@ -60,7 +61,7 @@ ENTRY(restore_image)
 	/* Flush TLB */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx	# PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3;
@@ -112,7 +113,7 @@ ENTRY(restore_registers)
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx;  # PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3
