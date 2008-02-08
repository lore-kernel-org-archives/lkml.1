Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYBHXPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYBHXPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYBHXPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:15:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40903 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbYBHXPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:15:22 -0500
Date: Sat, 9 Feb 2008 00:15:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080208231506.GA13350@elte.hu>
References: <200802081902.m18J2nOm005840@hera.kernel.org> <20080208230433.GA8524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208230433.GA8524@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> config attached. It seems all !PAE 32-bit kernel builds are broken due 
> to this. The patch below fixes it.

ok, the patch was against x86.git which had some other changes in this 
area - the one below applies to vanilla -git and fixes the bug.

	Ingo

----------------->
Subject: x86: fix pgtable_t build breakage
From: Ingo Molnar <mingo@elte.hu>

fix build breakage caused by commit 2f569afd9ced9ebec9.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/page_32.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/page_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/page_32.h
+++ linux-x86.q/include/asm-x86/page_32.h
@@ -50,11 +50,13 @@ typedef unsigned long	phys_addr_t;
 typedef union { pteval_t pte, pte_low; } pte_t;
 typedef pte_t boot_pte_t;
 
-typedef struct page *pgtable_t;
-
 #endif	/* __ASSEMBLY__ */
 #endif	/* CONFIG_X86_PAE */
 
+#ifndef __ASSEMBLY__
+typedef struct page *pgtable_t;
+#endif
+
 #ifdef CONFIG_HUGETLB_PAGE
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
