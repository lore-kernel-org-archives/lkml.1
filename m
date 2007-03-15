Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXCOWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXCOWP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbXCOWP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:26 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33688 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXCOWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:24 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 17 of 33] IB/ipath - remove unused register read routine
	ipath_read_kreg64_port()
X-Mercurial-Node: a023ffe32d9df8cba7d8b15c24e7918eeb236a2c
Message-Id: <a023ffe32d9df8cba7d8.1173995101@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:01 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID a023ffe32d9df8cba7d8b15c24e7918eeb236a2c
# Parent  4d22cec2265b606cecee72d5abca4436bb1e6cb7
IB/ipath - remove unused register read routine ipath_read_kreg64_port()

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 4d22cec2265b -r a023ffe32d9d drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
@@ -1804,29 +1804,6 @@ int ipath_set_lid(struct ipath_devdata *
 	return 0;
 }
 
-/**
- * ipath_read_kreg64_port - read a device's per-port 64-bit kernel register
- * @dd: the infinipath device
- * @regno: the register number to read
- * @port: the port containing the register
- *
- * Registers that vary with the chip implementation constants (port)
- * use this routine.
- */
-u64 ipath_read_kreg64_port(const struct ipath_devdata *dd, ipath_kreg regno,
-			   unsigned port)
-{
-	u16 where;
-
-	if (port < dd->ipath_portcnt &&
-	    (regno == dd->ipath_kregs->kr_rcvhdraddr ||
-	     regno == dd->ipath_kregs->kr_rcvhdrtailaddr))
-		where = regno + port;
-	else
-		where = -1;
-
-	return ipath_read_kreg64(dd, where);
-}
 
 /**
  * ipath_write_kreg_port - write a device's per-port 64-bit kernel register
diff -r 4d22cec2265b -r a023ffe32d9d drivers/infiniband/hw/ipath/ipath_iba6110.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
@@ -208,8 +208,8 @@ static const struct ipath_kregs ipath_ht
 	.kr_serdesstatus = IPATH_KREG_OFFSET(SerdesStatus),
 	.kr_xgxsconfig = IPATH_KREG_OFFSET(XGXSConfig),
 	/*
-	 * These should not be used directly via ipath_read_kreg64(),
-	 * use them with ipath_read_kreg64_port(),
+	 * These should not be used directly via ipath_write_kreg64(),
+	 * use them with ipath_write_kreg64_port(),
 	 */
 	.kr_rcvhdraddr = IPATH_KREG_OFFSET(RcvHdrAddr0),
 	.kr_rcvhdrtailaddr = IPATH_KREG_OFFSET(RcvHdrTailAddr0)
diff -r 4d22cec2265b -r a023ffe32d9d drivers/infiniband/hw/ipath/ipath_iba6120.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
@@ -207,8 +207,8 @@ static const struct ipath_kregs ipath_pe
 	.kr_ibpllcfg = IPATH_KREG_OFFSET(IBPLLCfg),
 
 	/*
-	 * These should not be used directly via ipath_read_kreg64(),
-	 * use them with ipath_read_kreg64_port()
+	 * These should not be used directly via ipath_write_kreg64(),
+	 * use them with ipath_write_kreg64_port(),
 	 */
 	.kr_rcvhdraddr = IPATH_KREG_OFFSET(RcvHdrAddr0),
 	.kr_rcvhdrtailaddr = IPATH_KREG_OFFSET(RcvHdrTailAddr0),
diff -r 4d22cec2265b -r a023ffe32d9d drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h	Thu Mar 15 14:34:25 2007 -0700
@@ -756,8 +756,6 @@ int ipath_eeprom_write(struct ipath_devd
 /* these are used for the registers that vary with port */
 void ipath_write_kreg_port(const struct ipath_devdata *, ipath_kreg,
 			   unsigned, u64);
-u64 ipath_read_kreg64_port(const struct ipath_devdata *, ipath_kreg,
-			   unsigned);
 
 /*
  * We could have a single register get/put routine, that takes a group type,
