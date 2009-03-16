Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZCPKgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZCPKgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZCPKfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:35:46 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39200 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbZCPKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:35:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] Char: isicom, prolong tty reference holding
Date: Mon, 16 Mar 2009 11:34:24 +0100
Message-Id: <1237199665-10675-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hold the tty reference a bit longer in isicom_shutdown_port, because
we use it later in the function, so that it won't disappear in the
meantime.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/isicom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 24aa6e8..855f375 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -897,8 +897,6 @@ static void isicom_shutdown_port(struct isi_port *port)
 
 	tty_port_free_xmit_buf(&port->port);
 	port->port.flags &= ~ASYNC_INITIALIZED;
-	/* 3rd October 2000 : Vinayak P Risbud */
-	tty_port_tty_set(&port->port, NULL);
 
 	/*Fix done by Anil .S on 30-04-2001
 	remote login through isi port has dtr toggle problem
@@ -925,6 +923,7 @@ static void isicom_shutdown_port(struct isi_port *port)
 		if (!card->count)
 			isicom_shutdown_board(card);
 	}
+	tty_port_tty_set(&port->port, NULL);
 }
 
 static void isicom_flush_buffer(struct tty_struct *tty)
-- 
1.6.2

