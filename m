Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZEZWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZEZWvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbZEZWtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:57280 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759809AbZEZWtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="693771896"
Message-Id: <20090526225148.141003582@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 5/7 v2] pcmcia/ds: prepare for FIRMWARE_NAME_MAX removal
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
