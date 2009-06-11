Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbZFKPHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbZFKPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZFKPHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:07:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763574AbZFKPHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:07:21 -0400
Date: Thu, 11 Jun 2009 17:07:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixlet
Message-ID: <20090611150712.GA13276@elte.hu>
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

A build warning on 32-bit slipped through (on a default-disabled 
config).

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      x86: memtest: use pointers of equal type for comparison


 arch/x86/mm/memtest.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c0bedcd..18d244f 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -40,21 +40,20 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 
 static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 {
-	u64 *p;
-	void *start, *end;
+	u64 *p, *start, *end;
 	u64 start_bad, last_bad;
 	u64 start_phys_aligned;
-	size_t incr;
+	const size_t incr = sizeof(pattern);
 
-	incr = sizeof(pattern);
 	start_phys_aligned = ALIGN(start_phys, incr);
 	start = __va(start_phys_aligned);
-	end = start + size - (start_phys_aligned - start_phys);
+	end = start + (size - (start_phys_aligned - start_phys)) / incr;
 	start_bad = 0;
 	last_bad = 0;
 
 	for (p = start; p < end; p++)
 		*p = pattern;
+
 	for (p = start; p < end; p++, start_phys_aligned += incr) {
 		if (*p == pattern)
 			continue;
