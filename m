Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0BDOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:40:22 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20754 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab0BDOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:40:17 -0500
Subject: [PATCH 20/30] hpsa: Don't return DID_NO_CONNECT when a device is
	merely not ready
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:43:05 -0600
Message-ID: <20100204144305.10406.63403.stgit@beardog.cce.hp.com>
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

hpsa: Don't return DID_NO_CONNECT when a device is merely not ready

Signed-off-by: Matt Gates <matthew.gates@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d07b3d3..320d686 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1029,7 +1029,6 @@ static void complete_scsi_command(struct CommandList *cp,
 				 * required
 				 */
 				if ((asc == 0x04) && (ascq == 0x03)) {
-					cmd->result = DID_NO_CONNECT << 16;
 					dev_warn(&h->pdev->dev, "cp %p "
 						"has check condition: unit "
 						"not ready, manual "

