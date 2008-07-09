Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYGILr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYGILr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYGILrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:47:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYGILrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:47:48 -0400
Date: Wed, 9 Jul 2008 13:47:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [patch] xen64: fix build error on 32-bit + !HIGHMEM  (was: Re:
	[PATCH 00 of 55] xen64: implement 64-bit Xen support)
Message-ID: <20080709114730.GA15238@elte.hu>
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709111219.GA24874@elte.hu>
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


another small build fixlet, on 32-bit.

	Ingo

---------------->
commit c3d03b62eb73cb66415b7bb3031981c6a0cb90c3
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jul 9 13:45:33 2008 +0200

    xen64: fix build error on 32-bit + !HIGHMEM
    
    fix:
    
    arch/x86/xen/enlighten.c: In function 'xen_set_fixmap':
    arch/x86/xen/enlighten.c:1127: error: 'FIX_KMAP_BEGIN' undeclared (first use in this function)
    arch/x86/xen/enlighten.c:1127: error: (Each undeclared identifier is reported only once
    arch/x86/xen/enlighten.c:1127: error: for each function it appears in.)
    arch/x86/xen/enlighten.c:1127: error: 'FIX_KMAP_END' undeclared (first use in this function)
    make[1]: *** [arch/x86/xen/enlighten.o] Error 1
    make: *** [arch/x86/xen/enlighten.o] Error 2
    
    FIX_KMAP_BEGIN is only available on HIGHMEM.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 776c0fb..3da6acb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1124,7 +1124,9 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
 	case FIX_VDSO:
+# ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
+# endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
 #endif
