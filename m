Return-Path: <linux-kernel-owner+w=401wt.eu-S966457AbZLHVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966457AbZLHVgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966254AbZLHVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:36:46 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46192 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbZLHVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:36:40 -0500
Subject: [PATCH 5/5] hpsa: suppress messages due to unsupport SCSI REPORT_LUNS
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 08 Dec 2009 15:38:32 -0600
Message-ID: <20091208213832.23493.17251.stgit@beardog.cce.hp.com>
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

hpsa: suppress messages due to unsupport SCSI REPORT_LUNS

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 380236a..22bca00 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -964,6 +964,13 @@ static void complete_scsi_command(struct CommandList *cp,
 				break;
 			}
 			if (sense_key == ILLEGAL_REQUEST) {
+				/*
+				 * SCSI REPORT_LUNS is commonly unsupported on
+				 * Smart Array.  Suppress noisy complaint.
+				 */
+				if (cp->Request.CDB[0] == REPORT_LUNS)
+					break;
+
 				/* If ASC/ASCQ indicate Logical Unit
 				 * Not Supported condition,
 				 */

