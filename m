Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYFTNgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYFTNgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYFTNge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:36:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYFTNgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:36:33 -0400
Date: Fri, 20 Jun 2008 15:36:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86: unify asm-x86/fixmap*.h
Message-ID: <20080620133618.GA27964@elte.hu>
References: <4858056D.7000500@goop.org> <20080620131041.GA19740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080620131041.GA19740@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> > Almost everything aside from the actual fixmap slot definitions is 
> > common, so move it all into the common fixmap.h header.
> 
> nice patches! I have created a new -tip topic for them: 
> tip/x86/fixmap, and have added them there. (This topic will also be in 
> auto-x86-next on the next integration run.)

found a build failure with:

  http://redhat.com/~mingo/misc/config-Fri_Jun_20_15_27_37_CEST_2008.bad

arch/x86/mm/pgtable.c:280: warning: ‘enum fixed_addresses' declared inside parameter list
arch/x86/mm/pgtable.c:280: warning: its scope is only this definition or declaration, which is probably not what you want
arch/x86/mm/pgtable.c:280: error: parameter 1 (‘idx') has incomplete type
arch/x86/mm/pgtable.c: In function ‘__native_set_fixmap':

due to:

7c7e6e07e2a7c0d2d96389f4f0540e44a80ecdaa is first bad commit
commit 7c7e6e07e2a7c0d2d96389f4f0540e44a80ecdaa
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Tue Jun 17 11:41:54 2008 -0700

    x86: unify __set_fixmap

    In both cases, I went with the 32-bit behaviour.

    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

fixed via the patch below.

	Ingo

-------->
commit b7429b1637b78fb272d42851ba8edd97e2ab08b1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 20 15:34:46 2008 +0200

    x86: unify __set_fixmap, fix
    
    fix build failure:
    
     arch/x86/mm/pgtable.c:280: warning: ‘enum fixed_addresses’ declared inside parameter list
     arch/x86/mm/pgtable.c:280: warning: its scope is only this definition or declaration, which is probably not what you want
     arch/x86/mm/pgtable.c:280: error: parameter 1 (‘idx’) has incomplete type
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 66535c1..45b99ac 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -2,6 +2,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
+#include <asm/fixmap.h>
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
