Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYBBNFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYBBNFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYBBNFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:05:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50758 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYBBNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:05:32 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Feb 2008 14:05:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] IEEE 1394 regression fix
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
Message-ID: <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem update.

It's telling.  I didn't run-time test the ieee1394 part of the post
2.6.24 patch queue on anything but i386...

Stefan Richter (1):
      ieee1394: sbp2: fix bogus s/g access change


 drivers/ieee1394/sbp2.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

commit 5fcf500058d5f06720302c5ce138c7bca93f7655
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Feb 1 22:31:10 2008 +0100

    ieee1394: sbp2: fix bogus s/g access change
    
    sg_dma_len(sg) is invalid before the s/g list is DMA-mapped.
    
    This fixes a post 2.6.24 regression which prevents access to SBP-2
    devices on several architectures, introduced by "ieee1394: sbp2: s/g
    list access cosmetics", commit 825f1df545ab0289185373b0eaf06fb0b3487422.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 2b889d9..28e155a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1465,10 +1465,9 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 	orb->misc |= ORB_SET_DIRECTION(orb_direction);
 
 	/* special case if only one element (and less than 64KB in size) */
-	if ((scsi_use_sg == 1) &&
-	    (sg_dma_len(sg) <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
+	if (scsi_use_sg == 1 && sg->length <= SBP2_MAX_SG_ELEMENT_LENGTH) {
 
-		cmd->dma_size = sg_dma_len(sg);
+		cmd->dma_size = sg->length;
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
 					    sg_page(sg), sg->offset,

-- 
Stefan Richter
-=====-==--- --=- ---=-
http://arcgraph.de/sr/

