Return-Path: <linux-kernel-owner+w=401wt.eu-S1765801AbXEUTZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765801AbXEUTZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765340AbXEUTV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46325 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765301AbXEUTVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:19 -0400
Message-Id: <20070521191715.934272000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:31 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 19/69] skge: default WOL should be magic only (rev2)
Content-Disposition: inline; filename=skge-default-wol-should-be-magic-only.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

By default, the skge driver now enables wake on magic and wake on PHY.
This is a bad default (bug), wake on PHY means machine will never shutdown 
if connected to a switch.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/net/skge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21.1.orig/drivers/net/skge.c
+++ linux-2.6.21.1/drivers/net/skge.c
@@ -3583,7 +3583,9 @@ static struct net_device *skge_devinit(s
 	skge->duplex = -1;
 	skge->speed = -1;
 	skge->advertising = skge_supported_modes(hw);
-	skge->wol = pci_wake_enabled(hw->pdev) ? wol_supported(hw) : 0;
+
+	if (pci_wake_enabled(hw->pdev))
+		skge->wol = wol_supported(hw) & WAKE_MAGIC;
 
 	hw->dev[port] = dev;
 

-- 
