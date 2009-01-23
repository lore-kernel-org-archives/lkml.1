Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbZAWB2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbZAWB2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZAWBPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:10 -0500
Received: from kroah.org ([198.145.64.141]:50586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760223AbZAWBO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:59 -0500
Date: Thu, 22 Jan 2009 17:12:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joe Chou <Joe.Chou@rdc.com.tw>,
       Florian Fainelli <florian@openwrt.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/46] r6040: fix wrong logic in mdio code
Message-ID: <20090123011215.GW19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r6040-fix-wrong-logic-in-mdio-code.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Chou <Joe.Chou@rdc.com.tw>

[ Upstream commit: 11e5e8f5d14a1229706576184d2cf4c4556ed94c ]

This patch fixes a reverse logic in the MDIO code.

Signed-off-by: Joe Chou <Joe.Chou@rdc.com.tw>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -214,7 +214,7 @@ static int r6040_phy_read(void __iomem *
 	/* Wait for the read bit to be cleared */
 	while (limit--) {
 		cmd = ioread16(ioaddr + MMDIO);
-		if (cmd & MDIO_READ)
+		if (!(cmd & MDIO_READ))
 			break;
 	}
 
@@ -233,7 +233,7 @@ static void r6040_phy_write(void __iomem
 	/* Wait for the write bit to be cleared */
 	while (limit--) {
 		cmd = ioread16(ioaddr + MMDIO);
-		if (cmd & MDIO_WRITE)
+		if (!(cmd & MDIO_WRITE))
 			break;
 	}
 }

