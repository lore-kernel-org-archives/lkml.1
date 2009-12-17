Return-Path: <linux-kernel-owner+w=401wt.eu-S1764795AbZLQOWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764795AbZLQOWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762715AbZLQOW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:22:28 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:11521 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764771AbZLQOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:22:27 -0500
Subject: [PATCH] hpsa: fix scsi status reporting yet again.
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, smcameron@yahoo.com
Date: Thu, 17 Dec 2009 08:23:34 -0600
Message-ID: <20091217142334.10948.47866.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix scsi status reporting yet again, reverting an earlier
attempt.  The status byte does not need to be shifted << 1.  Code
in other drivers that does "scp->result |= CHECK_CONDITION << 1;"
works because CHECK_CONDITION macro is pre-shifted right 1 bit.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 22bca00..1f4dd27 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -930,7 +930,7 @@ static void complete_scsi_command(struct CommandList *cp,
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
-	cmd->result |= (ei->ScsiStatus << 1);
+	cmd->result |= ei->ScsiStatus;
 
 	/* copy the sense data whether we need to or not. */
 	memcpy(cmd->sense_buffer, ei->SenseInfo,

