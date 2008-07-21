Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYGUOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYGUOjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYGUOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:39:38 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:62903 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYGUOjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:39:37 -0400
Date: Mon, 21 Jul 2008 23:41:28 +0900 (JST)
Message-Id: <20080721.234128.41011776.anemo@mba.ocn.ne.jp>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial_txx9: Fix build failure by tty_port conversion
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit df4f4dd429870f435f8d5d9d561db029a29f063b ("serial: use
tty_port"), serial_txx9 cause this build failure:

linux/drivers/serial/serial_txx9.c: In function 'receive_chars':
linux/drivers/serial/serial_txx9.c:275: error: 'struct uart_info' has no member named 'tty'

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 7ad2192..8fcb4c5 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -272,7 +272,7 @@ static void serial_txx9_initialize(struct uart_port *port)
 static inline void
 receive_chars(struct uart_txx9_port *up, unsigned int *status)
 {
-	struct tty_struct *tty = up->port.info->tty;
+	struct tty_struct *tty = up->port.info->port.tty;
 	unsigned char ch;
 	unsigned int disr = *status;
 	int max_count = 256;
