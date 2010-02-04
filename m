Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab0BDOm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:42:57 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31875 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab0BDOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:40:23 -0500
Subject: [PATCH 21/30] hpsa: Add an shost_to_hba helper function.
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:43:11 -0600
Message-ID: <20100204144310.10406.60867.stgit@beardog.cce.hp.com>
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

hpsa: Add an shost_to_hba helper function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 320d686..e81df76 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -197,6 +197,12 @@ static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev)
 	return (struct ctlr_info *) *priv;
 }
 
+static inline struct ctlr_info *shost_to_hba(struct Scsi_Host *sh)
+{
+	unsigned long *priv = shost_priv(sh);
+	return (struct ctlr_info *) *priv;
+}
+
 static struct task_struct *hpsa_scan_thread;
 static DEFINE_MUTEX(hpsa_scan_mutex);
 static LIST_HEAD(hpsa_scan_q);
@@ -381,8 +387,7 @@ static ssize_t host_store_rescan(struct device *dev,
 {
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
-	unsigned long *priv = shost_priv(shost);
-	h = (struct ctlr_info *) *priv;
+	h = shost_to_hba(shost);
 	if (add_to_scan_list(h)) {
 		wake_up_process(hpsa_scan_thread);
 		wait_for_completion_interruptible(&h->scan_wait);

