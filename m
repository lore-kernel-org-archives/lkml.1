Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbXHHNX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbXHHNX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbXHHNXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:23:45 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:37655 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136AbXHHNXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:23:44 -0400
Message-ID: <46B9C3B9.9010907@csr.com>
Date: Wed, 08 Aug 2007 14:23:05 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: [patch 1/3] sdio: add SDIO_FBR_BASE(f) macro
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BB0.4000100@csr.com>	<20070807221719.7c89e5b6@poseidon.drzeus.cx>	<46B998B5.9040203@csr.com> <20070808123759.26a74b2a@poseidon.drzeus.cx> <46B9C38C.1030708@csr.com>
In-Reply-To: <46B9C38C.1030708@csr.com>
Content-Type: multipart/mixed;
 boundary="------------080207070804080808050509"
X-OriginalArrivalTime: 08 Aug 2007 13:23:05.0544 (UTC) FILETIME=[40F9C480:01C7D9BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080207070804080808050509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

--------------080207070804080808050509
Content-Type: text/x-patch;
 name="sdio-add-fbr-base-macro.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="sdio-add-fbr-base-macro.patch"

sdio: add SDIO_FBR_BASE(f) macro

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

--------------080207070804080808050509--
