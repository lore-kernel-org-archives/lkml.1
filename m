Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXKTRVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXKTRVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbXKTRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:21:46 -0500
Received: from mail0.scram.de ([78.47.204.202]:60100 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbXKTRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:21:45 -0500
X-Spam-Score: -4.087
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47431799.6010802@scram.de>
Date: Tue, 20 Nov 2007 18:21:29 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       paulus@samba.org, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] powerpc: Change _tlbie arguments to reflect new API
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A new pid argument has been added to _tlbie for 4xx platforms.
Add this argument to the 8xx path in mem.c, as well. As 8xx
does not need th epid information, this argument can always be 0.

Signed-off-by: Jochen Friedrich <jochen@scram.de>

  CC      arch/powerpc/mm/mem.o
arch/powerpc/mm/mem.c: In function 'update_mmu_cache':
arch/powerpc/mm/mem.c:467: error: too few arguments to function '_tlbie'
make[1]: *** [arch/powerpc/mm/mem.o] Error 1
make: *** [arch/powerpc/mm] Error 2
---
 arch/powerpc/mm/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 81eb96e..e07852e 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -464,7 +464,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
 		 * we invalidate the TLB here, thus avoiding dcbst
 		 * misbehaviour.
 		 */
-		_tlbie(address);
+		_tlbie(address, 0);
 #endif
 		if (!PageReserved(page)
 		    && !test_bit(PG_arch_1, &page->flags)) {
-- 
1.5.3.4

