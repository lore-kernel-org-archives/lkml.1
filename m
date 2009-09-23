Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIWOP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIWOP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZIWOP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:15:29 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58679 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZIWOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:15:24 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/5] SCSI: aacraid, fix memory leak
Date: Wed, 23 Sep 2009 16:15:31 +0200
Message-Id: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak on one fail path in aac_send_raw_srb. Add kfree
there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/aacraid/commctrl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0391d75..5c9a8be 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536) {
+					kfree (usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-- 
1.6.4.2

