Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAXJe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAXJe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYAXJet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:34:49 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:33606 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYAXJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:34:48 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFC 4/5] Char: moxa, fix TIOC(G/S)SOFTCAR param
Date: Thu, 24 Jan 2008 10:32:44 +0100
Message-Id: <1201167165-27635-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
References: <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to ioctl_list, both have int * as a param, not ulong *.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index ad51916..cbf8e97 100644
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
1.5.3.7

