Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbZLJNhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbZLJNhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760518AbZLJNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:37:04 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46599 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbZLJNhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:37:02 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -3rd repost 2/3] SCSI: remove unnecessary NULL test
Date: Thu, 10 Dec 2009 14:37:03 +0100
Message-Id: <1260452224-31760-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.5
In-Reply-To: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
References: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7091050..64bbc28 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 		skb = skb_peek(&c3cn->receive_queue);
 	}
 	read_unlock(&c3cn->callback_lock);
-	if (c3cn) {
-		c3cn->copied_seq += read;
-		cxgb3i_c3cn_rx_credits(c3cn, read);
-	}
+	c3cn->copied_seq += read;
+	cxgb3i_c3cn_rx_credits(c3cn, read);
 	conn->rxdata_octets += read;
 
 	if (err) {
-- 
1.6.5.5

