Return-Path: <linux-kernel-owner+w=401wt.eu-S1422872AbXCGRQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422872AbXCGRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422871AbXCGRQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:43418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422856AbXCGRQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:11 -0500
Message-Id: <20070307171434.256837089@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
       Bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       Pavel Roskin <proski@gnu.org>, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 059/101] bcm43xx: Fix assertion failures in interrupt handler
Content-Disposition: inline; filename=bcm43xx-fix-assertion-failures-in-interrupt-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Pavel Roskin <proski@gnu.org>

In the bcm43xx interrupt handler, sanity checks are wrongly done before the
verification that the interrupt is for the bcm43xx.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6.20.1/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1864,9 +1864,6 @@ static irqreturn_t bcm43xx_interrupt_han
 
 	spin_lock(&bcm->irq_lock);
 
-	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
-	assert(bcm->current_core->id == BCM43xx_COREID_80211);
-
 	reason = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
 	if (reason == 0xffffffff) {
 		/* irq not for us (shared irq) */
@@ -1877,6 +1874,9 @@ static irqreturn_t bcm43xx_interrupt_han
 	if (!reason)
 		goto out;
 
+	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
+	assert(bcm->current_core->id == BCM43xx_COREID_80211);
+
 	bcm->dma_reason[0] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA0_REASON)
 			     & 0x0001DC00;
 	bcm->dma_reason[1] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA1_REASON)

--
