Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXH1Lnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXH1Lnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXH1Lnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:43:45 -0400
Received: from mail0.scram.de ([78.47.204.202]:50574 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088AbXH1Lno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:43:44 -0400
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 07:43:43 EDT
X-Spam-Score: -4.061
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <46D40510.3060805@scram.de>
Date: Tue, 28 Aug 2007 13:20:48 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH] ppc32/8xx: Fix r3 trashing due to 8MB TLB page instantiation
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------000709070107090300080001"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709070107090300080001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Instantiation of 8MB pages on the TLB cache for the kernel static
mapping trashes r3 register on !CONFIG_8xx_CPU6 configurations.
This ensures r3 gets saved and restored.

This has been posted to linuxppc-embedded by Marcelo Tosatti
<marcelo@kvack.org>, but only an incomplete version of the patch
has been applied in c51e078f82096a7d35ac8ec2416272e843a0e1c4.
This patch adds the rest of the fix.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/ppc/kernel/head_8xx.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

This can be pulled from git://git.bocc.de/dbox2.git ppc-fixes

--------------000709070107090300080001
Content-Type: text/x-patch;
 name="d14ebb1e9d133983252a14f2ef037f76969ab3c6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="d14ebb1e9d133983252a14f2ef037f76969ab3c6.diff"

diff --git a/arch/ppc/kernel/head_8xx.S b/arch/ppc/kernel/head_8xx.S
index 944c35c..eb8d26f 100644
--- a/arch/ppc/kernel/head_8xx.S
+++ b/arch/ppc/kernel/head_8xx.S
@@ -495,9 +495,7 @@ LoadLargeDTLB:
 	lwz	r11, 4(r0)
 
 	lwz	r12, 16(r0)
-#ifdef CONFIG_8xx_CPU6
 	lwz	r3, 8(r0)
-#endif
 	rfi
 
 /* This is the data TLB error on the MPC8xx.  This could be due to


--------------000709070107090300080001--
