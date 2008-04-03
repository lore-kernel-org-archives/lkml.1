Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYDCAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYDCAeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbYDCAdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:33:46 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:39551 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbYDCAdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WU3GuU3mqr6O2avbamZZ7rnrSbAkz4bi/VykgX1cErI0hzh6cdT7ZaxtoIUkrPTb+/pj9a6yXvXKBYz1P6K1vwQxPEOdu5bbFPbxmsikrtIbIPZrphTPZFK6l+ToOvSbZyHX+sbhbX3YHnRNqBAFg2D4ACPzHROwV/0pXB+q0wc=
Subject: [PATCH 2/7] net: marvell.c fix sparse shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:35 -0700
Message-Id: <1207182815.5740.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other if blocks don't redeclare temp, remove the redeclaration in
the final if() block.

drivers/net/phy/marvell.c:214:7: warning: symbol 'temp' shadows an earlier one
drivers/net/phy/marvell.c:160:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/phy/marvell.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3353991..32a8503 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -211,8 +211,6 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	}
 
 	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
-		int temp;
-
 		temp = phy_read(phydev, MII_M1111_PHY_EXT_SR);
 		if (temp < 0)
 			return temp;
-- 
1.5.5.rc1.135.g8527


