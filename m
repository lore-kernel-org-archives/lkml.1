Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0BDOjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:35 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:7737 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab0BDOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:31 -0500
Subject: [PATCH 03/30] hpsa: avoid unwanted promotion from unsigned to signed
	for raid level index
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:41:38 -0600
Message-ID: <20100204144138.10406.57370.stgit@beardog.cce.hp.com>
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

hpsa: avoid unwanted promotion from unsigned to signed for raid level index

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0f4a1f3..ee9db5e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -431,7 +431,7 @@ static ssize_t raid_level_show(struct device *dev,
 	     struct device_attribute *attr, char *buf)
 {
 	ssize_t l = 0;
-	int rlevel;
+	unsigned char rlevel;
 	struct ctlr_info *h;
 	struct scsi_device *sdev;
 	struct hpsa_scsi_dev_t *hdev;
@@ -455,7 +455,7 @@ static ssize_t raid_level_show(struct device *dev,
 
 	rlevel = hdev->raid_level;
 	spin_unlock_irqrestore(&h->lock, flags);
-	if (rlevel < 0 || rlevel > RAID_UNKNOWN)
+	if (rlevel > RAID_UNKNOWN)
 		rlevel = RAID_UNKNOWN;
 	l = snprintf(buf, PAGE_SIZE, "RAID %s\n", raid_label[rlevel]);
 	return l;

