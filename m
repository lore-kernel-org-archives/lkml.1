Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab0BDOkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:40:13 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39366 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab0BDOkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:40:07 -0500
Subject: [PATCH 18/30] hpsa: Return DID_RESET for commands which complete with
	status of UNSOLICITED ABORT
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:55 -0600
Message-ID: <20100204144255.10406.57450.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Gates <matthew.gates@hp.com>

hpsa: Return DID_RESET for commands which complete with status of UNSOLICITED ABORT.
The commands should be retried, and this will make that happen, instead of resulting
in an i/o error.

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cc9e92a..bcc51f9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1128,7 +1128,7 @@ static void complete_scsi_command(struct CommandList *cp,
 		dev_warn(&h->pdev->dev, "cp %p reports abort failed\n", cp);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		cmd->result = DID_ABORT << 16;
+		cmd->result = DID_RESET << 16;
 		dev_warn(&h->pdev->dev, "cp %p aborted do to an unsolicited "
 			"abort\n", cp);
 		break;

