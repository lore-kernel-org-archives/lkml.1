Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXIWUR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXIWUR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 16:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXIWURf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 16:17:35 -0400
Received: from mail0.scram.de ([78.47.204.202]:50396 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821AbXIWURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 16:17:33 -0400
X-Spam-Score: -4.27
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.1 AWL AWL: From: address is in the auto white-list
Message-ID: <46F6C9D7.4060700@scram.de>
Date: Sun, 23 Sep 2007 22:17:27 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH3/4] [PPC] Compile fix for 8xx CPM Ehernet driver
Content-Type: multipart/mixed;
 boundary="------------010209040705070605030000"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010209040705070605030000
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Add #include <asm/cacheflush.h> for flush_dcache_range
to make the driver compile again.

  CC      arch/ppc/8xx_io/enet.o
arch/ppc/8xx_io/enet.c: In function 'scc_enet_start_xmit':
arch/ppc/8xx_io/enet.c:240: error: implicit declaration of function
'flush_dcache_range'
make[1]: *** [arch/ppc/8xx_io/enet.o] Error 1
make: *** [arch/ppc/8xx_io] Error 2

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/ppc/8xx_io/enet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

--------------010209040705070605030000
Content-Type: text/x-patch;
 name="c10ab471b95ac13c93b0ae36d169756ae694a77d.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="c10ab471b95ac13c93b0ae36d169756ae694a77d.diff"

diff --git a/arch/ppc/8xx_io/enet.c b/arch/ppc/8xx_io/enet.c
index 703d47e..eace3bc 100644
--- a/arch/ppc/8xx_io/enet.c
+++ b/arch/ppc/8xx_io/enet.c
@@ -44,6 +44,7 @@
 #include <asm/mpc8xx.h>
 #include <asm/uaccess.h>
 #include <asm/commproc.h>
+#include <asm/cacheflush.h>
 
 /*
  *				Theory of Operation


--------------010209040705070605030000--
