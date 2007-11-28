Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbXK1UZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbXK1UZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXK1UZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:25:12 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40161 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXK1UZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:25:11 -0500
Subject: PATCH 2.6.24-rc3-mm2 - build breakage - bnx2x depends on
	ZLIB_INFLATE
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 28 Nov 2007 15:25:24 -0500
Message-Id: <1196281524.5318.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Couldn't find one of these on the lists...

PATCH 2.6.24-rc3-mm1:  bnx2x depends on ZLIB_INFLATE

The bnx2x module depends on the zlib_inflate functions.  The
build will fail if ZLIB_INFLATE has not been selected manually
or by building another module that automatically selects it.

Modify BNX2X config option to 'select ZLIB_INFLATE' like BNX2
and others.  This seems to fix it.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: Linux/drivers/net/Kconfig
===================================================================
--- Linux.orig/drivers/net/Kconfig	2007-11-28 10:41:23.000000000 -0500
+++ Linux/drivers/net/Kconfig	2007-11-28 12:40:16.000000000 -0500
@@ -2606,6 +2606,7 @@ config TEHUTI
 config BNX2X
 	tristate "Broadcom NetXtremeII 10Gb support"
 	depends on PCI
+	select ZLIB_INFLATE
 	help
 	  This driver supports Broadcom NetXtremeII 10 gigabit Ethernet cards.
 	  To compile this driver as a module, choose M here: the module


