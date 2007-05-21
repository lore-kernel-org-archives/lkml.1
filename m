Return-Path: <linux-kernel-owner+w=401wt.eu-S934458AbXEUThn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbXEUThn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765559AbXEUTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:34 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46531 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765550AbXEUTWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:33 -0400
Message-Id: <20070521191716.364864000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 20/69] skge: allow WOL except for known broken chips
Content-Disposition: inline; filename=skge-allow-wol-except-for-known-broken-chips.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

Wake On Lan works correctly on Yukon-FE and other variants.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/skge.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/skge.c
+++ linux-2.6.21.1/drivers/net/skge.c
@@ -135,10 +135,13 @@ static void skge_get_regs(struct net_dev
 /* Wake on Lan only supported on Yukon chips with rev 1 or above */
 static u32 wol_supported(const struct skge_hw *hw)
 {
-	if (hw->chip_id == CHIP_ID_YUKON && hw->chip_rev != 0)
-		return WAKE_MAGIC | WAKE_PHY;
-	else
+	if (hw->chip_id == CHIP_ID_GENESIS)
 		return 0;
+
+	if (hw->chip_id == CHIP_ID_YUKON && hw->chip_rev == 0)
+		return 0;
+
+	return WAKE_MAGIC | WAKE_PHY;
 }
 
 static u32 pci_wake_enabled(struct pci_dev *dev)

-- 
