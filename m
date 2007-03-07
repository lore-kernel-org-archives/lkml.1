Return-Path: <linux-kernel-owner+w=401wt.eu-S1422844AbXCGRPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844AbXCGRPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422841AbXCGRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXCGRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:26 -0500
Message-Id: <20070307171341.990097701@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, John Linville <linville@tuxdriver.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Larry Finger <larry.finger@lwfinger.net>, Michael Buesch <mb@bu3sch.de>
Subject: [patch 044/101] bcm43xx: fix for 4309
Content-Disposition: inline; filename=bcm43xx-fix-for-4309.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Brivio <stefano.brivio@polimi.it>

BCM4309 devices aren't working properly as A PHYs aren't supported yet, but
we probe 802.11a cores anyway. This fixes it, while still allowing for A PHY code
to be developed in the future.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6.20.1/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -2736,8 +2736,9 @@ static int bcm43xx_probe_cores(struct bc
 				 * dangling pins on the second core. Be careful
 				 * and ignore these cores here.
 				 */
-				if (bcm->pci_dev->device != 0x4324) {
-					dprintk(KERN_INFO PFX "Ignoring additional 802.11 core.\n");
+				if (1 /*bcm->pci_dev->device != 0x4324*/ ) {
+				/* TODO: A PHY */
+					dprintk(KERN_INFO PFX "Ignoring additional 802.11a core.\n");
 					continue;
 				}
 			}

--
