Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZLJNhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZLJNhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbZLJNhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:37:03 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46597 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953AbZLJNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:37:02 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -3rd repost 1/3] SCSI: aacraid, fix memory leak
Date: Thu, 10 Dec 2009 14:37:02 +0100
Message-Id: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

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
1.6.5.5

