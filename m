Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZCTJOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZCTJOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZCTJOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:14:11 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56802 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZCTJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:14:10 -0400
Date: Fri, 20 Mar 2009 10:14:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, Ilya Yanok <yanok@emcraft.com>,
       netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 20 - dnet build break on s390
Message-ID: <20090320101401.6ea261ea@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dnet: Dave DNET breaks an allyesconfig build on s390:

  CC      drivers/net/dnet.o
drivers/net/dnet.c: In function 'dnet_readw_mac':
drivers/net/dnet.c:36: error: implicit declaration of function 'writel'
drivers/net/dnet.c:43: error: implicit declaration of function 'readl'
drivers/net/dnet.c: In function 'dnet_probe':
drivers/net/dnet.c:873: error: implicit declaration of function 'ioremap'
drivers/net/dnet.c:873: warning: assignment makes pointer from integer without a cast
drivers/net/dnet.c:939: error: implicit declaration of function 'iounmap'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/drivers/net/Kconfig
===================================================================
--- linux-next.orig/drivers/net/Kconfig
+++ linux-next/drivers/net/Kconfig
@@ -1042,7 +1042,7 @@ config NI65
 
 config DNET
 	tristate "Dave ethernet support (DNET)"
-	depends on NET_ETHERNET
+	depends on NET_ETHERNET && HAS_IOMEM
 	select PHYLIB
 	help
 	  The Dave ethernet interface (DNET) is found on Qong Board FPGA.
