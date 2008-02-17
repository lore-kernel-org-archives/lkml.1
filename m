Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbYBQN5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbYBQN5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbYBQN5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:57:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46722 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbYBQN5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:57:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Feb 2008 14:57:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
Message-ID: <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescan-scsi-bus used to add SBP-2 targets which weren't there.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1974,6 +1974,9 @@ static int sbp2scsi_slave_alloc(struct s
 {
 	struct sbp2_lu *lu = (struct sbp2_lu *)sdev->host->hostdata[0];
 
+	if (sdev->lun != 0 || sdev->id != lu->ud->id || sdev->channel != 0)
+		return -ENODEV;
+
 	lu->sdev = sdev;
 	sdev->allow_restart = 1;
 

-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/

