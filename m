Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbZLKX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbZLKX2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761788AbZLKX2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:49 -0500
Received: from kroah.org ([198.145.64.141]:50413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762805AbZLKX2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <scottk@digi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/58] jsm: remove the ch_custom_speed field
Date: Fri, 11 Dec 2009 15:27:47 -0800
Message-Id: <1260574122-10676-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently the ch_custom_speed field exists but is never used,
so, this patch removes it.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

