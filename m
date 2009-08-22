Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZHVHEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZHVHEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 03:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933238AbZHVHEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 03:04:42 -0400
Received: from server1.wserver.cz ([82.113.45.157]:50810 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234AbZHVHEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 03:04:42 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Char: riscom8, fix shutdown declaration
Date: Sat, 22 Aug 2009 09:04:42 +0200
Message-Id: <1250924682-20483-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_ops.shutdown takes only one parameter: tty port. Remove
the second one and use port->tty where needed instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/riscom8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 7b5623b..3c7cf2c 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -934,7 +934,7 @@ static void rc_flush_buffer(struct tty_struct *tty)
 	tty_wakeup(tty);
 }
 
-static void rc_close_port(struct tty_port *port, struct tty_struct *tty)
+static void rc_close_port(struct tty_port *port)
 {
 	unsigned long flags;
 	struct riscom_port *rp = container_of(port, struct riscom_port, port);
@@ -969,7 +969,7 @@ static void rc_close_port(struct tty_port *port, struct tty_struct *tty)
 				break;
 		}
 	}
-	rc_shutdown_port(tty, bp, rp);
+	rc_shutdown_port(port->tty, bp, rp);
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-- 
1.6.3.3

