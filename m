Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab0BDOjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 09:39:24 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3551 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab0BDOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 09:39:21 -0500
Subject: [PATCH 09/30] hpsa: use kzalloc not kmalloc plus memset
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 08:42:09 -0600
Message-ID: <20100204144209.10406.7946.stgit@beardog.cce.hp.com>
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

hpsa: use kzalloc not kmalloc plus memset

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index add2ed5..bd081fe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1405,13 +1405,12 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device)
 {
 #define OBDR_TAPE_INQ_SIZE 49
-	unsigned char *inq_buff = NULL;
+	unsigned char *inq_buff;
 
-	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
+	inq_buff = kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	if (!inq_buff)
 		goto bail_out;
 
-	memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);
 	/* Do an inquiry to the device to see what it is. */
 	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
 		(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {

