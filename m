Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYKGQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYKGQai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYKGQa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:30:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYKGQa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:30:28 -0500
Date: Fri, 7 Nov 2008 17:30:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fix
Message-ID: <20081107163011.GA3781@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (1):
      x86, xen: fix use of pgd_page now that it really does return a page


 arch/x86/xen/mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aba77b2..49697d8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -874,7 +874,7 @@ static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 #else /* CONFIG_X86_32 */
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is pinnable */
-	xen_pin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+	xen_pin_page(mm, pgd_page(pgd[pgd_index(TASK_SIZE)]),
 		     PT_PMD);
 #endif
 	xen_do_pin(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(pgd)));
@@ -991,7 +991,7 @@ static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
 
 #ifdef CONFIG_X86_PAE
 	/* Need to make sure unshared kernel PMD is unpinned */
-	xen_unpin_page(mm, virt_to_page(pgd_page(pgd[pgd_index(TASK_SIZE)])),
+	xen_unpin_page(mm, pgd_page(pgd[pgd_index(TASK_SIZE)]),
 		       PT_PMD);
 #endif
 
