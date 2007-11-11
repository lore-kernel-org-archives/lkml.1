Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXKKRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXKKRId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 12:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXKKRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 12:08:24 -0500
Received: from mail0.scram.de ([78.47.204.202]:59698 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbXKKRIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 12:08:23 -0500
X-Spam-Score: -3.876
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <473736FB.7090609@scram.de>
Date: Sun, 11 Nov 2007 18:08:11 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       paulus@samba.org
Subject: [PATCH] powerpc: Add support for PORTA sor and PORTB odr registers
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PORTA has an so register and PORTB had an odr register, as well.
However, the PORTB odr register is only 16bit.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/sysdev/commproc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index f6a6378..a9f5fcf 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -438,6 +438,13 @@ static void cpm1_set_pin32(int port, int pin, int flags)
 	else
 		clrbits32(&iop->par, pin);
 
+	if (port == CPM_PORTB) {
+		if (flags & CPM_PIN_OPENDRAIN)
+			setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+		else
+			clrbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+	}
+
 	if (port == CPM_PORTE) {
 		if (flags & CPM_PIN_SECONDARY)
 			setbits32(&iop->sor, pin);
@@ -471,7 +478,7 @@ static void cpm1_set_pin16(int port, int pin, int flags)
 	else
 		clrbits16(&iop->par, pin);
 
-	if (port == CPM_PORTC) {
+	if ((port == CPM_PORTA) || (port == CPM_PORTC)) {
 		if (flags & CPM_PIN_SECONDARY)
 			setbits16(&iop->sor, pin);
 		else
-- 
1.5.3.5

