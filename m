Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbXINM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbXINM0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXINM0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:26:05 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:43488 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXINM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:26:03 -0400
Date: Fri, 14 Sep 2007 13:25:55 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>
cc: netdev@vger.kernel.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sb1250-mac.c: Fix "stats" references
Message-ID: <Pine.LNX.4.64N.0709141316410.1926@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix build errors resulting from a recent commit that added references to 
"stats" through "dev" from sbdma_rx_process() and sbdma_tx_process(), but 
no definitions of that variable.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 This is probably the simplest fix possible, though at this point it is of 
question whether it is still "struct sbmac_softc *" that should be passed 
to these functions.  I'll leave it to another occasion though.

 Applies under patch-netdev-2.6.23-rc6-20070913-sb1250-mac-typedef-8.

 Please apply,

  Maciej

patch-netdev-2.6.23-rc6-20070913-sb1250-mac-fix-1
diff -up --recursive --new-file linux-netdev-2.6.23-rc6-20070913.macro/drivers/net/sb1250-mac.c linux-netdev-2.6.23-rc6-20070913/drivers/net/sb1250-mac.c
--- linux-netdev-2.6.23-rc6-20070913.macro/drivers/net/sb1250-mac.c	2007-09-13 17:27:52.000000000 +0000
+++ linux-netdev-2.6.23-rc6-20070913/drivers/net/sb1250-mac.c	2007-09-14 12:06:15.000000000 +0000
@@ -1187,6 +1187,7 @@ static void sbmac_netpoll(struct net_dev
 static int sbdma_rx_process(struct sbmac_softc *sc,sbmacdma_t *d,
                              int work_to_do, int poll)
 {
+	struct net_device *dev = sc->sbm_dev;
 	int curidx;
 	int hwidx;
 	sbdmadscr_t *dsc;
@@ -1348,6 +1349,7 @@ done:
 
 static void sbdma_tx_process(struct sbmac_softc *sc,sbmacdma_t *d, int poll)
 {
+	struct net_device *dev = sc->sbm_dev;
 	int curidx;
 	int hwidx;
 	sbdmadscr_t *dsc;
