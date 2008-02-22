Return-Path: <linux-kernel-owner+w=401wt.eu-S933491AbYBVUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbYBVUMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933138AbYBVUKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:10:22 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:44571 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761465AbYBVUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:10:19 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Subject: [PATCH 21/21] Char: moxa, add firmware loading fix
Date: Fri, 22 Feb 2008 21:09:35 +0100
Message-Id: <1203710975-24675-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be more verbose on fw load fail as noted by Oyvind.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 3c248bb..57616c1 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -846,7 +846,10 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 
 	ret = request_firmware(&fw, file, dev);
 	if (ret) {
-		printk(KERN_ERR "request_firmware failed\n");
+		printk(KERN_ERR "MOXA: request_firmware failed. Make sure "
+				"you've placed '%s' file into your firmware "
+				"loader directory (e.g. /lib/firmware)\n",
+				file);
 		goto err_free;
 	}
 
-- 
1.5.4.1

