Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYAHXpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYAHXpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYAHXpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:45:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbYAHXpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:45:04 -0500
Date: Wed, 9 Jan 2008 00:44:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080108234449.GA24274@elte.hu>
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108232803.GA19906@elte.hu>
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

> it's one of these patches:
> 
>  Subject: x86: move all asm/pgtable constants into one place
>  Subject: x86: avoid name conflict for Voyager leave_mm
>  Subject: x86/pgtable: unify pagetable accessors

it's the first one that causes the crash.

reviewed it carefully and found the bug below. Checking now whether it 
fixes the crash.

	Ingo

---
 include/asm-x86/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/include/asm-x86/pgtable.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/pgtable.h
+++ linux-x86.q/include/asm-x86/pgtable.h
@@ -68,7 +68,7 @@ extern unsigned long long __PAGE_KERNEL,
 #endif	/* __ASSEMBLER__ */
 #else
 #define __PAGE_KERNEL_EXEC						\
-	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
+	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
 #define __PAGE_KERNEL		(__PAGE_KERNEL_EXEC | _PAGE_NX)
 #endif
 

