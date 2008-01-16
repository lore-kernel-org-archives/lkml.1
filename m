Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYAPPrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYAPPrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYAPPr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:47:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYAPPr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:47:27 -0500
Date: Wed, 16 Jan 2008 16:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116154710.GA28946@elte.hu>
References: <patchbomb.1200435425@localhost> <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu> <200801161626.01711.ak@suse.de> <478E3411.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478E3411.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> > Yes, but if you cast to long the result will be 32bit again. Or do 
> > you rely on it being always used in 64bit signed context with sign 
> > extension? While that might work it would seem rather fragile to me, 
> > just asking for similar future bugs.
> 
> Even if conversion is to 64-bit unsigned, the value (being signed) 
> will be sign-extended first (to preserve its value modulo 2**<target 
> type width>).

yes. It would be nice if Andi could test my fix instead of arguing why 
he thinks it's unlikely to work ;-)

(i've got the cleanup patch below as well ontop of today's x86.git which 
includes the first fix, but it's an RFC as it has wider impact and might 
break stuff.)

	Ingo

--------------->
Subject: x86: PAGE_MASK cleanup
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/page.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/page.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/page.h
+++ linux-x86.q/include/asm-x86/page.h
@@ -6,12 +6,12 @@
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK	(~(PAGE_SIZE-1))
+#define PAGE_MASK	(_AT(phys_addr_t, ~(PAGE_SIZE-1)))
 
 #ifdef __KERNEL__
 
 #define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
-#define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))
+#define PTE_MASK		PHYSICAL_PAGE_MASK
 
 #define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
 #define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
