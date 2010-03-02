Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0CBXvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:51:23 -0500
Received: from kroah.org ([198.145.64.141]:51587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab0CBXgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/36] tty: char: mxser, remove unnecessary tty test
Date: Tue,  2 Mar 2010 15:36:19 -0800
Message-Id: <1267573003-782-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found unnecessary test in mxser_startup.

tty is dereferenced earlier, the test is superfluous. Remove it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mxser.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 3d92306..e0c5d2a 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -895,8 +895,7 @@ static int mxser_activate(struct tty_port *port, struct tty_struct *tty)
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
1.7.0.1

