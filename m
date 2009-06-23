Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZFWHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZFWHcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZFWHbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:31:49 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:53974 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZFWHbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:31:48 -0400
Date: Tue, 23 Jun 2009 09:31:20 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: let SJA1000 driver depend on HAS_IOMEM
Message-ID: <20090623073120.GA5955@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this compile error on s390:

drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_read_reg':
drivers/net/can/sja1000/sja1000_platform.c:42: error: implicit declaration of function 'ioread8'
drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_write_reg':
drivers/net/can/sja1000/sja1000_platform.c:47: error: implicit declaration of function 'iowrite8'
drivers/net/can/sja1000/sja1000_platform.c: In function 'sp_probe':
drivers/net/can/sja1000/sja1000_platform.c:79: error: implicit declaration of function 'ioremap_nocache'

Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/net/can/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/can/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/can/Kconfig
+++ linux-2.6/drivers/net/can/Kconfig
@@ -36,7 +36,7 @@ config CAN_CALC_BITTIMING
 	  If unsure, say Y.
 
 config CAN_SJA1000
-	depends on CAN_DEV
+	depends on CAN_DEV && HAS_IOMEM
 	tristate "Philips SJA1000"
 	---help---
 	  Driver for the SJA1000 CAN controllers from Philips or NXP
