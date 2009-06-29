Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbZF2Ih2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbZF2Ih2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZF2IhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:37:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZF2IhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:37:18 -0400
Date: Mon, 29 Jun 2009 10:36:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fix
Message-ID: <20090629083636.GA5385@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

This reverts a commit that caused a regression.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      Revert "x86: cap iomem_resource to addressable physical memory"


 arch/x86/kernel/cpu/common.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b26d4d..f1961c0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -848,9 +848,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	numa_add_cpu(smp_processor_id());
 #endif
-
-	/* Cap the iomem address space to what is addressable on all CPUs */
-	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
 }
 
 #ifdef CONFIG_X86_64
