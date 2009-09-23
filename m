Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274AbZIWOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbZIWOPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZIWOPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:15:31 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58683 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZIWOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:15:24 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/5] SCSI: remove unnecessary NULL test
Date: Wed, 23 Sep 2009 16:15:32 +0200
Message-Id: <1253715335-6723-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
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
1.6.4.2

