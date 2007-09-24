Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbXIXRRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbXIXRRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764986AbXIXRQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:16:57 -0400
Received: from mail0.scram.de ([78.47.204.202]:53985 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762594AbXIXRQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:16:56 -0400
X-Spam-Score: -3.919
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <46F7F0BF.5040605@scram.de>
Date: Mon, 24 Sep 2007 19:15:43 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH#2 4/4] [POWERPC] Fix cpm_uart driver
Content-Type: multipart/mixed;
 boundary="------------090203050004050103050109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090203050004050103050109
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


in cpm_uart_cpm1.h, DPRAM_BASE is assigned an address derived from cpmp.
On ARC=ppc, this is a physical address with 1:1 DMA mapping which can't
be used for arithmetric compare operations with virtual addresses
returned by cpm_dpram_addr. This patch changes the assignment to use
cpm_dpram_addr as well, like in cpm_uart_cpm2.h.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/serial/cpm_uart/cpm_uart_cpm1.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--------------090203050004050103050109
Content-Type: text/x-patch;
 name="e99364db4224fcfaf74389d1b59ec0637d899c17.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e99364db4224fcfaf74389d1b59ec0637d899c17.diff"

diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm1.h b/drivers/serial/cpm_uart/cpm_uart_cpm1.h
index a99e45e..2a64778 100644
--- a/drivers/serial/cpm_uart/cpm_uart_cpm1.h
+++ b/drivers/serial/cpm_uart/cpm_uart_cpm1.h
@@ -37,6 +37,6 @@ static inline void cpm_set_smc_fcr(volatile smc_uart_t * up)
 	up->smc_tfcr = SMC_EB;
 }
 
-#define DPRAM_BASE	((unsigned char *)&cpmp->cp_dpmem[0])
+#define DPRAM_BASE	((unsigned char *)cpm_dpram_addr(0))
 
 #endif


--------------090203050004050103050109--
