Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZKKQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZKKQu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZKKQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:50:25 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1676 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbZKKQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:50:23 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/17] hpsa: fix typo that causes scsi status to be lost
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:51:50 -0600
Message-ID: <20091111165150.17754.50167.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: fix typo that causes scsi status to be lost

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5097995..06eeefd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -987,7 +987,7 @@ static void complete_scsi_command(struct CommandList *cp,
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1010,7 +1010,7 @@ static void complete_scsi_command(struct CommandList *cp,
 		 */
 		if (ei->ScsiStatus) {
 
-			cmd->result |= (ei->ScsiStatus < 1);
+			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",

