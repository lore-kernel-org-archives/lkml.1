Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0CNXA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 19:00:58 -0400
Received: from mail.pxnet.com ([195.227.45.7]:59818 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab0CNXA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 19:00:57 -0400
Message-Id: <6064316e1863fe50dc7cb9c47b6d64728b878f06.1268580322.git.tilman@imap.cc>
In-Reply-To: <cover.1268580322.git.tilman@imap.cc>
References: <cover.1268580322.git.tilman@imap.cc>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 2/3] gigaset: correct clearing of at_state strings on RING
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
Date: Sun, 14 Mar 2010 23:58:05 +0100 (CET)
X-Spam-Score: -2.189 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RING handling, clear the table of received parameter strings in
a loop like everywhere else, instead of by enumeration which had
already gotten out of sync.

Impact: minor bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
CC: stable@kernel.org
---
Note to -stable: applies correctly to 2.6.33.

 drivers/isdn/gigaset/ev-layer.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index c8f89b7..206c380 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -1258,14 +1258,10 @@ static void do_action(int action, struct cardstate *cs,
 		 * note that bcs may be NULL if no B channel is free
 		 */
 		at_state2->ConState = 700;
-		kfree(at_state2->str_var[STR_NMBR]);
-		at_state2->str_var[STR_NMBR] = NULL;
-		kfree(at_state2->str_var[STR_ZCPN]);
-		at_state2->str_var[STR_ZCPN] = NULL;
-		kfree(at_state2->str_var[STR_ZBC]);
-		at_state2->str_var[STR_ZBC] = NULL;
-		kfree(at_state2->str_var[STR_ZHLC]);
-		at_state2->str_var[STR_ZHLC] = NULL;
+		for (i = 0; i < STR_NUM; ++i) {
+			kfree(at_state2->str_var[i]);
+			at_state2->str_var[i] = NULL;
+		}
 		at_state2->int_var[VAR_ZCTP] = -1;
 
 		spin_lock_irqsave(&cs->lock, flags);
-- 
1.6.5.3.298.g39add

