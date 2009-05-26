Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZEZRkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZEZRkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZEZRjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:39:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:12809 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbZEZRjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="518993417"
Message-Id: <20090526174159.517598981@linux.intel.com>
References: <20090526174012.423883376@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 May 2009 19:40:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Damien Bergamini <damien.bergamini@free.fr>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/6] atm/ueagle-atm: prepare for FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-ueagle.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>
To: Damien Bergamini <damien.bergamini@free.fr>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch replaces the shared FIRMWARE_NAME_MAX definition with a ueagle
local one.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

---
 drivers/usb/atm/ueagle-atm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: iwm-2.6/drivers/usb/atm/ueagle-atm.c
===================================================================
--- iwm-2.6.orig/drivers/usb/atm/ueagle-atm.c	2009-05-26 17:11:36.000000000 +0200
+++ iwm-2.6/drivers/usb/atm/ueagle-atm.c	2009-05-26 17:11:44.000000000 +0200
@@ -306,6 +306,7 @@ enum {
 #define FW_GET_BYTE(p)	*((__u8 *) (p))
 
 #define FW_DIR "ueagle-atm/"
+#define UEA_FW_NAME_MAX 30
 #define NB_MODEM 4
 
 #define BULK_TIMEOUT 300
@@ -1564,9 +1565,9 @@ static void cmvs_file_name(struct uea_so
 		file = cmv_file[sc->modem_index];
 
 	strcpy(cmv_name, FW_DIR);
-	strlcat(cmv_name, file, FIRMWARE_NAME_MAX);
+	strlcat(cmv_name, file, UEA_FW_NAME_MAX);
 	if (ver == 2)
-		strlcat(cmv_name, ".v2", FIRMWARE_NAME_MAX);
+		strlcat(cmv_name, ".v2", UEA_FW_NAME_MAX);
 }
 
 static int request_cmvs_old(struct uea_softc *sc,
@@ -1574,7 +1575,7 @@ static int request_cmvs_old(struct uea_s
 {
 	int ret, size;
 	u8 *data;
-	char cmv_name[FIRMWARE_NAME_MAX]; /* 30 bytes stack variable */
+	char cmv_name[UEA_FW_NAME_MAX]; /* 30 bytes stack variable */
 
 	cmvs_file_name(sc, cmv_name, 1);
 	ret = request_firmware(fw, cmv_name, &sc->usb_dev->dev);
@@ -1608,7 +1609,7 @@ static int request_cmvs(struct uea_softc
 	int ret, size;
 	u32 crc;
 	u8 *data;
-	char cmv_name[FIRMWARE_NAME_MAX]; /* 30 bytes stack variable */
+	char cmv_name[UEA_FW_NAME_MAX]; /* 30 bytes stack variable */
 
 	cmvs_file_name(sc, cmv_name, 2);
 	ret = request_firmware(fw, cmv_name, &sc->usb_dev->dev);

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
