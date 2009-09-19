Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZISVoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZISVoE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZISVoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:03 -0400
Received: from kroah.org ([198.145.64.141]:40552 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbZISVoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 65/79] tty: riscom8, fix shutdown declaration
Date: Sat, 19 Sep 2009 14:37:10 -0700
Message-Id: <1253396244-7885-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

tty_port_ops.shutdown takes only one parameter: tty port. Remove
the second one and use port->tty where needed instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.4.2

