Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbYB1T57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbYB1T57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764479AbYB1Twz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:52:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60261 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762746AbYB1Twy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:52:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:52:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: fw-sbp2: remove unnecessary memset
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
Message-ID: <tkrat.c60546aba45e2e85@s5r6.in-berlin.de>
References: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

orb came from kzalloc.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1426,7 +1426,6 @@ static int sbp2_scsi_queuecommand(struct
 	orb->cmd  = cmd;
 
 	orb->request.next.high   = cpu_to_be32(SBP2_ORB_NULL);
-	orb->request.next.low    = 0x0;
 	/*
 	 * At speed 100 we can do 512 bytes per packet, at speed 200,
 	 * 1024 bytes per packet etc.  The SBP-2 max_payload field
@@ -1446,8 +1445,6 @@ static int sbp2_scsi_queuecommand(struct
 	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
 		goto out;
 
-	memset(orb->request.command_block,
-	       0, sizeof(orb->request.command_block));
 	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
 
 	orb->base.callback = complete_command_orb;

-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

