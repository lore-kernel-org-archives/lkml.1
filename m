Return-Path: <linux-kernel-owner+w=401wt.eu-S1765847AbYCSURh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765847AbYCSURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbYCSTjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:35952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbYCSTiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lizzNoVtIAdlvuZr+gd2KA8xsngrQfQWKvPkHf7U0v+hMusMPCGhlgpl0CrgupoEZdGp33358KB8dt2L+sNL2iJWrrBvQ/dA/ceGayq8820uBzcB7rqSzeE0bCC880hCgCRkcDoD8iCRMPFnUmGlD04P7YpaflZSZW9PJC+bWKg=
From: Denis Cheng <crquan@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: removed one unneeded shost->active_mode assignment
Date: Thu, 20 Mar 2008 03:10:20 +0800
Message-Id: <1205953820-8501-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following if/else statement, shost->active_mode will always be set,
so this assignment is unneeded.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/hosts.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 880c78b..553d443 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -341,7 +341,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
-	shost->active_mode = sht->supported_mode;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
-- 
1.5.4.4

