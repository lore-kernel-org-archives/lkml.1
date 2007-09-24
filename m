Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbXIXRQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbXIXRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762208AbXIXRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:16:45 -0400
Received: from mail0.scram.de ([78.47.204.202]:39084 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760396AbXIXRQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:16:44 -0400
X-Spam-Score: -3.902
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F7F0B7.2090205@scram.de>
Date: Mon, 24 Sep 2007 19:15:35 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH#2 3/4] [PPC] Compile fix for 8xx CPM Ehernet driver
Content-Type: multipart/mixed;
 boundary="------------020809090603030000000606"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809090603030000000606
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

--------------020809090603030000000606
Content-Type: text/x-patch;
 name="bf5c2f419c8f731109b1c39e390338dcea780e94.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bf5c2f419c8f731109b1c39e390338dcea780e94.diff"

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


--------------020809090603030000000606--
