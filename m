Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYDRX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYDRX1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYDRXXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:21 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40631 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYDRXXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:16 -0400
Message-Id: <1fe60a9e2aaf5ddc410e5eefd7aa1163821c59b5.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: ralf@linux-mips.org
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/15] [MIPS] pmc-sierra/msp71xx/msp_hwbutton.c: minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:23:01 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove always-true test

- neaten request_irq() indentation

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
index ab96a2d..11769b5 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -126,9 +126,6 @@ static irqreturn_t hwbutton_handler(int irq, void *data)
 	struct hwbutton_interrupt *hirq = data;
 	unsigned long cic_ext = *CIC_EXT_CFG_REG;
 
-	if (irq != hirq->irq)
-		return IRQ_NONE;
-
 	if (CIC_EXT_IS_ACTIVE_HI(cic_ext, hirq->eirq)) {
 		/* Interrupt: pin is now HI */
 		CIC_EXT_SET_ACTIVE_LO(cic_ext, hirq->eirq);
@@ -164,7 +161,7 @@ static int msp_hwbutton_register(struct hwbutton_interrupt *hirq)
 	*CIC_EXT_CFG_REG = cic_ext;
 
 	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
-				hirq->name, (void *)hirq);
+			   hirq->name, hirq);
 }
 
 static int __init msp_hwbutton_setup(void)
-- 
1.5.4.1

