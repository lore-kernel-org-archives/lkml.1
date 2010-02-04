Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab0BDOjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:20 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38668 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0BDOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:16 -0500
Subject: [PATCH 08/30] hpsa: use sizeof() not an inline constant in memset.
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:04 -0600
Message-ID: <20100204144204.10406.68867.stgit@beardog.cce.hp.com>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: use sizeof() not an inline constant in memset.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8389cce..add2ed5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1363,9 +1363,8 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 		dev_err(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
 		return -1;
 	}
-
-	memset(&scsi3addr[0], 0, 8); /* address the controller */
-
+	/* address the controller */
+	memset(scsi3addr, 0, sizeof(scsi3addr));
 	fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
 		buf, bufsize, 0, scsi3addr, TYPE_CMD);
 	if (extended_response)

