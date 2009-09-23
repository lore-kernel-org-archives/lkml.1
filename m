Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZIWOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZIWOP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZIWOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:15:28 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58691 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZIWOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:15:25 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5] SCSI: qla2xxx, fix NULL-ptr dereference
Date: Wed, 23 Sep 2009 16:15:34 +0200
Message-Id: <1253715335-6723-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a NULL-ptr dereference on one fail path in
qla25xx_create_rsp_que. It jumps to que_failed label and
qla25xx_free_rsp_que there dereferences rsp which is NULL.

Return with ENOMEM directly instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 42b799a..8b4e723 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -659,7 +659,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (rsp == NULL) {
 		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
 				" response que\n");
-		goto que_failed;
+		return -ENOMEM;
 	}
 
 	rsp->length = RESPONSE_ENTRY_CNT_MQ;
-- 
1.6.4.2

