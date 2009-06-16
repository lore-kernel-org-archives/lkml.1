Return-Path: <linux-kernel-owner+w=401wt.eu-S936403AbZFPFzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936403AbZFPFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934708AbZFPFvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:08 -0400
Received: from kroah.org ([198.145.64.141]:48341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933716AbZFPFvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Damien Bergamini <damien.bergamini@free.fr>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/64] firmware: atm/ueagle-atm: prepare for FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:06 -0700
Message-Id: <1245131213-24168-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch replaces the shared FIRMWARE_NAME_MAX definition with a ueagle
local one.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Damien Bergamini <damien.bergamini@free.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/atm/ueagle-atm.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 9cf9ff6..d171b56 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -306,6 +306,7 @@ enum {
 #define FW_GET_BYTE(p)	*((__u8 *) (p))
 
 #define FW_DIR "ueagle-atm/"
+#define UEA_FW_NAME_MAX 30
 #define NB_MODEM 4
 
 #define BULK_TIMEOUT 300
@@ -1564,9 +1565,9 @@ static void cmvs_file_name(struct uea_softc *sc, char *const cmv_name, int ver)
 		file = cmv_file[sc->modem_index];
 
 	strcpy(cmv_name, FW_DIR);
-	strlcat(cmv_name, file, FIRMWARE_NAME_MAX);
+	strlcat(cmv_name, file, UEA_FW_NAME_MAX);
 	if (ver == 2)
-		strlcat(cmv_name, ".v2", FIRMWARE_NAME_MAX);
+		strlcat(cmv_name, ".v2", UEA_FW_NAME_MAX);
 }
 
 static int request_cmvs_old(struct uea_softc *sc,
@@ -1574,7 +1575,7 @@ static int request_cmvs_old(struct uea_softc *sc,
 {
 	int ret, size;
 	u8 *data;
-	char cmv_name[FIRMWARE_NAME_MAX]; /* 30 bytes stack variable */
+	char cmv_name[UEA_FW_NAME_MAX]; /* 30 bytes stack variable */
 
 	cmvs_file_name(sc, cmv_name, 1);
 	ret = request_firmware(fw, cmv_name, &sc->usb_dev->dev);
@@ -1608,7 +1609,7 @@ static int request_cmvs(struct uea_softc *sc,
 	int ret, size;
 	u32 crc;
 	u8 *data;
-	char cmv_name[FIRMWARE_NAME_MAX]; /* 30 bytes stack variable */
+	char cmv_name[UEA_FW_NAME_MAX]; /* 30 bytes stack variable */
 
 	cmvs_file_name(sc, cmv_name, 2);
 	ret = request_firmware(fw, cmv_name, &sc->usb_dev->dev);
-- 
1.6.3.2

