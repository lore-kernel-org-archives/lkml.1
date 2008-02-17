Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYBQN4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYBQN4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYBQN4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:56:34 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46686 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYBQN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:56:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 17 Feb 2008 14:56:19 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: fix NULL pointer deref in slave_alloc
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Message-ID: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a kernel bug when running rescan-scsi-bus while a FireWire disk is
connected:  http://bugzilla.kernel.org/show_bug.cgi?id=10008

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1473,6 +1473,10 @@ static int sbp2_scsi_slave_alloc(struct 
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
+	/* (Re-)Adding logical units via the SCSI stack is not supported. */
+	if (!lu)
+		return -ENOSYS;
+
 	sdev->allow_restart = 1;
 
 	/*

-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/

