Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbYFDRxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbYFDRxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbYFDRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:53:14 -0400
Received: from smtp.eurescom.eu ([89.31.1.171]:41130 "EHLO smtp.eurescom.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbYFDRxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:53:13 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 13:53:13 EDT
From: Sven Schnelle <svens@stackframe.org>
To: hskinnemoen@atmel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] macb: use random mac if stored address in EEPROM is invalid
Organization: private
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Wed, 04 Jun 2008 19:44:20 +0200
Message-ID: <87wsl56qob.fsf@apollo.stackframe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should use a random mac address if the EEPROM doesn't contain a valid
one. This makes life on Boards with unprogrammed EEPROM devices easier.

Signed-off-by: Sven Schnelle <svens@stackframe.org>

---
 drivers/net/macb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 92dccd4..e346302 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -80,8 +80,12 @@ static void __init macb_get_hwaddr(struct macb *bp)
        addr[4] = top & 0xff;
        addr[5] = (top >> 8) & 0xff;
 
-       if (is_valid_ether_addr(addr))
+       if (is_valid_ether_addr(addr)) {
                memcpy(bp->dev->dev_addr, addr, sizeof(addr));
+       } else {
+               dev_info(&bp->pdev->dev, "invalid hw address, using
random\n");
+               random_ether_addr(bp->dev->dev_addr);
+       }
 }
 
 static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
