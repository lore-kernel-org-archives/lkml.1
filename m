Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569Ab0CNXBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 19:01:14 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:59828 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab0CNXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 19:01:04 -0400
Message-Id: <3ba816ff92f2dad24a5265f8f213a63debe9c6e6.1268580322.git.tilman@imap.cc>
In-Reply-To: <cover.1268580322.git.tilman@imap.cc>
References: <cover.1268580322.git.tilman@imap.cc>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 3/3] gigaset: prune use of tty_buffer_request_room
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
Date: Sun, 14 Mar 2010 23:58:05 +0100 (CET)
X-Spam-Score: -2.189 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling tty_buffer_request_room() before tty_insert_flip_string()
is unnecessary, costs CPU and for big buffers can mess up the
multi-page allocation avoidance.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, stable@kernel.org
---
Note to -stable: applies correctly to 2.6.33 with fuzz 2.

 drivers/isdn/gigaset/interface.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index a1bcbc2..f0dc6c9 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -628,7 +628,6 @@ void gigaset_if_receive(struct cardstate *cs,
 	if (tty == NULL)
 		gig_dbg(DEBUG_IF, "receive on closed device");
 	else {
-		tty_buffer_request_room(tty, len);
 		tty_insert_flip_string(tty, buffer, len);
 		tty_flip_buffer_push(tty);
 	}
-- 
1.6.5.3.298.g39add

