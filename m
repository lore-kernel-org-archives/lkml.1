Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbXL3OA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbXL3OA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbXL3N7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:59:12 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47433 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXL3N7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:59:05 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 4/5] Char: mxser, simplify mxser_get_serial_info
Date: Sun, 30 Dec 2007 14:58:57 +0100
Message-Id: <1199023138-27917-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize temp structure directly with proper values without first zeroing
it and setting later as suggested by Jan.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/char/mxser.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 7003855..c6651f3 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1168,21 +1168,18 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 static int mxser_get_serial_info(struct mxser_port *info,
 		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
-
-	if (!retinfo)
-		return -EFAULT;
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->tty->index;
-	tmp.port = info->ioaddr;
-	tmp.irq = info->board->irq;
-	tmp.flags = info->flags;
-	tmp.baud_base = info->baud_base;
-	tmp.close_delay = info->close_delay;
-	tmp.closing_wait = info->closing_wait;
-	tmp.custom_divisor = info->custom_divisor;
-	tmp.hub6 = 0;
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->tty->index,
+		.port = info->ioaddr,
+		.irq = info->board->irq,
+		.flags = info->flags,
+		.baud_base = info->baud_base,
+		.close_delay = info->close_delay,
+		.closing_wait = info->closing_wait,
+		.custom_divisor = info->custom_divisor,
+		.hub6 = 0
+	};
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
-- 
1.5.3.6

