Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab0CJFLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:11:00 -0500
Received: from services04.student.cs.uwaterloo.ca ([129.97.152.11]:33330 "EHLO
	services04.student.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab0CJFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:10:57 -0500
Date: Wed, 10 Mar 2010 00:10:46 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH,REGRESSION] Staging: et131x: Properly disable FC in txmac.
Message-ID: <20100310051046.GA646@cpu18.student.cs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (services04.student.cs.uwaterloo.ca [129.97.152.11]); Wed, 10 Mar 2010 00:10:52 -0500 (EST)
X-Miltered: at mailchk-m02 with ID 4B9729DA.001 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: feeb38c6-8494-43c6-80cb-a122b361ba4e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

FC disable is bit 3 of the txmac ctl register, but commit
6720949d55623cb8c4cb6b06f218d8be68780a6f accidentally changed
the code to set bit 2 instead.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---
 drivers/staging/et131x/et1310_mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index a292b1e..737a9f5 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -226,7 +226,7 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 	}
 
 	/* Enable TXMAC */
-	ctl |= 0x05;	/* TX mac enable, FC disable */
+	ctl |= 0x09;	/* TX mac enable, FC disable */
 	writel(ctl, &etdev->regs->txmac.ctl);
 
 	/* Ready to start the RXDMA/TXDMA engine */
-- 
1.6.4.4
