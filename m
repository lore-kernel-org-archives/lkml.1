Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZIWONe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZIWONe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIWONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:13:32 -0400
Received: from server1.wserver.cz ([82.113.45.157]:53602 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZIWONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:13:30 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Char: mxser, remove unnecessary tty test
Date: Wed, 23 Sep 2009 16:13:41 +0200
Message-Id: <1253715222-6643-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found unnecessary test in mxser_startup.

tty is dereferenced earlier, the test is superfluous. Remove it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 5e28d39..859ffb3 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -905,8 +905,7 @@ static int mxser_startup(struct tty_struct *tty)
 	if (inb(info->ioaddr + UART_LSR) == 0xff) {
 		spin_unlock_irqrestore(&info->slock, flags);
 		if (capable(CAP_SYS_ADMIN)) {
-			if (tty)
-				set_bit(TTY_IO_ERROR, &tty->flags);
+			set_bit(TTY_IO_ERROR, &tty->flags);
 			return 0;
 		} else
 			return -ENODEV;
-- 
1.6.4.2

