Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZKDQPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZKDQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbZKDQPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:15:18 -0500
Received: from server1.wserver.cz ([82.113.45.157]:34195 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZKDQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:15:17 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: aacraid@adaptec.com, james.smart@emulex.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -2nd repost 1/4] SCSI: aacraid, fix memory leak
Date: Wed,  4 Nov 2009 17:15:18 +0100
Message-Id: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
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

