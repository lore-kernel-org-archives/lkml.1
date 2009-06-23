Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZFWHcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZFWHcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZFWHcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:32:20 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:39401 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZFWHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:32:19 -0400
Date: Tue, 23 Jun 2009 09:32:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Richard Rojfors <richard.rojfors.ext@mocean-labs.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: let KS8842 driver depend on HAS_IOMEM
Message-ID: <20090623073206.GB5955@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this compile error on s390:

  CC      drivers/net/ks8842.o
drivers/net/ks8842.c: In function 'ks8842_select_bank':
drivers/net/ks8842.c:124: error: implicit declaration of function 'iowrite16'
drivers/net/ks8842.c: In function 'ks8842_write8':
drivers/net/ks8842.c:131: error: implicit declaration of function 'iowrite8'

Cc: Richard Rojfors <richard.rojfors.ext@mocean-labs.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/net/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/Kconfig
+++ linux-2.6/drivers/net/Kconfig
@@ -1725,6 +1725,7 @@ config TLAN
 
 config KS8842
 	tristate "Micrel KSZ8842"
+	depends on HAS_IOMEM
 	help
 	  This platform driver is for Micrel KSZ8842 chip.
 
