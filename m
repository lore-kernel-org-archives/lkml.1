Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZEZRlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZEZRlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZEZRkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:40:31 -0400
Received: from mga06.intel.com ([134.134.136.21]:33870 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757115AbZEZRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="415781734"
Message-Id: <20090526174219.161131129@linux.intel.com>
References: <20090526174012.423883376@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 May 2009 19:40:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 5/6] pcmcia/ds: prepare for FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-ds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
With the FIRMWARE_NAME_MAX removal, the ds.c reference becomes useless as we
dont need to check for the firmware name length anymore.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

---
 drivers/pcmcia/ds.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: iwm-2.6/drivers/pcmcia/ds.c
===================================================================
--- iwm-2.6.orig/drivers/pcmcia/ds.c	2009-05-26 17:32:21.000000000 +0200
+++ iwm-2.6/drivers/pcmcia/ds.c	2009-05-26 17:33:07.000000000 +0200
@@ -828,7 +828,6 @@ static int pcmcia_load_firmware(struct p
 {
 	struct pcmcia_socket *s = dev->socket;
 	const struct firmware *fw;
-	char path[FIRMWARE_NAME_MAX];
 	int ret = -ENOMEM;
 	int no_funcs;
 	int old_funcs;
@@ -839,16 +838,7 @@ static int pcmcia_load_firmware(struct p
 
 	ds_dev_dbg(1, &dev->dev, "trying to load CIS file %s\n", filename);
 
-	if (strlen(filename) > (FIRMWARE_NAME_MAX - 1)) {
-		dev_printk(KERN_WARNING, &dev->dev,
-			   "pcmcia: CIS filename is too long [%s]\n",
-			   filename);
-		return -EINVAL;
-	}
-
-	snprintf(path, sizeof(path), "%s", filename);
-
-	if (request_firmware(&fw, path, &dev->dev) == 0) {
+	if (request_firmware(&fw, filename, &dev->dev) == 0) {
 		if (fw->size >= CISTPL_MAX_CIS_SIZE) {
 			ret = -EINVAL;
 			dev_printk(KERN_ERR, &dev->dev,

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
