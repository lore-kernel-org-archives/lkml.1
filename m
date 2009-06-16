Return-Path: <linux-kernel-owner+w=401wt.eu-S936460AbZFPF4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936460AbZFPF4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935307AbZFPFvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:11 -0400
Received: from kroah.org ([198.145.64.141]:48354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672AbZFPFvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/64] firmware: pcmcia/ds: prepare for FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:09 -0700
Message-Id: <1245131213-24168-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
With the FIRMWARE_NAME_MAX removal, the ds.c reference becomes useless as we
dont need to check for the firmware name length anymore.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/ds.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 47cab31..8f2bb01 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -828,7 +828,6 @@ static int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
 {
 	struct pcmcia_socket *s = dev->socket;
 	const struct firmware *fw;
-	char path[FIRMWARE_NAME_MAX];
 	int ret = -ENOMEM;
 	int no_funcs;
 	int old_funcs;
@@ -839,16 +838,7 @@ static int pcmcia_load_firmware(struct pcmcia_device *dev, char * filename)
 
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
1.6.3.2

