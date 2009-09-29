Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZI2SRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZI2SRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZI2SQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:16:59 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:38409 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZI2SQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:16:58 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com,
       =?utf-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>
Subject: [PATCH 1/5] jsm: remove the ch_custom_speed field
Date: Tue, 29 Sep 2009 15:16:55 -0300
Message-Id: <f495925e581a2bc22df785754699cab5ba4c5d1b.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the ch_custom_speed field exists but is never used,
so, this patch removes it.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h     |    1 -
 drivers/serial/jsm/jsm_neo.c |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index 4e5f3bd..afcbee2 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -216,7 +216,6 @@ struct jsm_channel {
 	u8		ch_startc;	/* Start character		*/
 
 	u32		ch_old_baud;	/* Cache of the current baud */
-	u32		ch_custom_speed;/* Custom baud, if set */
 
 	u32		ch_wopen;	/* Waiting for open process cnt */
 
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index b4b124e..088e702 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -957,10 +957,6 @@ static void neo_param(struct jsm_channel *ch)
 		ch->ch_old_baud = 0;
 		return;
 
-	} else if (ch->ch_custom_speed) {
-			baud = ch->ch_custom_speed;
-			if (ch->ch_flags & CH_BAUD0)
-				ch->ch_flags &= ~(CH_BAUD0);
 	} else {
 		int i;
 		unsigned int cflag;
-- 
1.6.0.4

