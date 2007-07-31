Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbXGaSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbXGaSOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765021AbXGaSNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:13:52 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3004 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763696AbXGaSNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:13:51 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 38] drivers/char/ip2/ip2main.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:13:50 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312013.51172.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/ip2/ip2main.c | 104398 -> 104346 (-52 bytes)
 drivers/char/ip2/ip2main.o | 210710 -> 210702 (-8 bytes)

 drivers/char/ip2/ip2main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/char/ip2/ip2main.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/char/ip2/ip2main.c	2007-07-31 20:04:19.000000000 +0200
@@ -646,10 +646,9 @@ ip2_loadmain(int *iop, int *irqp, unsign

 	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
 		if ( ip2config.addr[i] ) {
-			pB = kmalloc( sizeof(i2eBordStr), GFP_KERNEL);
-			if ( pB != NULL ) {
+			pB = kzalloc(sizeof(i2eBordStr), GFP_KERNEL);
+			if (pB) {
 				i2BoardPtrTable[i] = pB;
-				memset( pB, 0, sizeof(i2eBordStr) );
 				iiSetAddress( pB, ip2config.addr[i], ii2DelayTimer );
 				iiReset( pB );
 			} else {
