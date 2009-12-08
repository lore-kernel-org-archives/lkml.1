Return-Path: <linux-kernel-owner+w=401wt.eu-S966510AbZLHVtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966510AbZLHVtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966501AbZLHVtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:49:45 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:19646 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966470AbZLHVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:49:44 -0500
Subject: [PATCH 4/5] hpsa: Fix incorrect SCSI status reporting
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 08 Dec 2009 15:38:27 -0600
Message-ID: <20091208213827.23493.88533.stgit@beardog.cce.hp.com>
In-Reply-To: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
References: <20091208213514.23493.86458.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: Fix incorrect SCSI status reporting

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0e696ee..380236a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -930,7 +930,7 @@ static void complete_scsi_command(struct CommandList *cp,
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus);
+	cmd->result |= (ei->ScsiStatus << 1);
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,
@@ -991,7 +991,6 @@ static void complete_scsi_command(struct CommandList *cp,
 
 
 			/* Must be some other type of check condition */
-			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has check condition: "
 					"unknown type: "
 					"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
@@ -1013,8 +1012,6 @@ static void complete_scsi_command(struct CommandList *cp,
 		 * Pass it up to the upper layers...
 		 */
 		if (ei->ScsiStatus) {
-
-			cmd->result |= (ei->ScsiStatus << 1);
 			dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
 				"Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
 				"Returning result: 0x%x\n",

