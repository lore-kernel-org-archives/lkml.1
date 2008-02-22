Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYBVOs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYBVOs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYBVOrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:47:31 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:42263 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYBVOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:47:28 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <alan@lxorguk.ukuu.org.uk>,
       Oyvind Aabling <Oyvind.Aabling@uni-c.dk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 04/19] Char: moxa, fix TIOC(G/S)SOFTCAR param
Date: Fri, 22 Feb 2008 15:46:31 +0100
Message-Id: <1203691606-9310-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
References: <1203691606-9310-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to ioctl_list, both have int * as a param, not ulong *.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
---
 drivers/char/moxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index f841b1f..428c138 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -741,9 +741,9 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		MoxaPortSendBreak(ch->port, arg);
 		return (0);
 	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) argp);
+		return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)argp);
 	case TIOCSSOFTCAR:
-		if(get_user(retval, (unsigned long __user *) argp))
+		if (get_user(retval, (int __user *)argp))
 			return -EFAULT;
 		arg = retval;
 		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) |
-- 
1.5.4.1

