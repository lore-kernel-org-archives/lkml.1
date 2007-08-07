Return-Path: <linux-kernel-owner+w=401wt.eu-S933989AbXHGMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbXHGMzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbXHGMzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:55:40 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:59192 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764AbXHGMzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:55:37 -0400
Message-ID: <46B86B60.5020600@csr.com>
Date: Tue, 07 Aug 2007 13:53:52 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 1/4] sdio: parameterize SDIO FBR register defines
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com> <20070806220145.66b97559@poseidon.drzeus.cx> <46B86ADB.90000@csr.com>
In-Reply-To: <46B86ADB.90000@csr.com>
Content-Type: multipart/mixed;
 boundary="------------040606030902030202030207"
X-OriginalArrivalTime: 07 Aug 2007 12:53:58.0467 (UTC) FILETIME=[05393930:01C7D8F2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040606030902030202030207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------040606030902030202030207
Content-Type: text/x-patch;
 name="sdio-parameterize-sdio-fbr-register-defines.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-parameterize-sdio-fbr-register-defines.patch"

sdio: parameterize SDIO FBR register defines

Signed-off-by: David Vrabel <david.vrabel@csr.com>
---
Index: mmc/drivers/mmc/core/sdio.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio.c	2007-08-06 14:37:30.000000000 +0100
+++ mmc/drivers/mmc/core/sdio.c	2007-08-06 17:30:14.000000000 +0100
@@ -30,7 +30,7 @@
 	unsigned char data;
 
 	ret = mmc_io_rw_direct(func->card, 0, 0,
-		func->num * 0x100 + SDIO_FBR_STD_IF, 0, &data);
+		SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF, 0, &data);
 	if (ret)
 		goto out;
 
@@ -38,7 +38,7 @@
 
 	if (data == 0x0f) {
 		ret = mmc_io_rw_direct(func->card, 0, 0,
-			func->num * 0x100 + SDIO_FBR_STD_IF_EXT, 0, &data);
+			SDIO_FBR_BASE(func->num) + SDIO_FBR_STD_IF_EXT, 0, &data);
 		if (ret)
 			goto out;
 	}
Index: mmc/drivers/mmc/core/sdio_cis.c
===================================================================
--- mmc.orig/drivers/mmc/core/sdio_cis.c	2007-08-06 14:37:30.000000000 +0100
+++ mmc/drivers/mmc/core/sdio_cis.c	2007-08-06 17:31:02.000000000 +0100
@@ -250,7 +250,7 @@
 			fn = 0;
 
 		ret = mmc_io_rw_direct(card, 0, 0,
-				       fn * 0x100 + SDIO_FBR_CIS + i, 0, &x);
+			SDIO_FBR_BASE(fn) + SDIO_FBR_CIS + i, 0, &x);
 		if (ret)
 			return ret;
 		ptr |= x << (i * 8);
Index: mmc/include/linux/mmc/sdio.h
===================================================================
--- mmc.orig/include/linux/mmc/sdio.h	2007-08-06 14:37:35.000000000 +0100
+++ mmc/include/linux/mmc/sdio.h	2007-08-06 17:29:21.000000000 +0100
@@ -132,6 +132,8 @@
  * Function Basic Registers (FBR)
  */
 
+#define SDIO_FBR_BASE(f)	((f) * 0x100) /* base of function f's FBRs */
+
 #define SDIO_FBR_STD_IF		0x00
 
 #define  SDIO_FBR_SUPPORTS_CSA	0x40	/* supports Code Storage Area */

--------------040606030902030202030207--
