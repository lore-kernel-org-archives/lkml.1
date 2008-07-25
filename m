Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYGYIm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYGYIm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYGYImt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:42:49 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:54288 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYGYIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:42:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: mxser, ratelimit ioctl warning
Date: Fri, 25 Jul 2008 10:39:50 +0200
Message-Id: <1216975190-6531-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get major ioctl prints out a warning, make it ratelimited.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/mxser.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 48676ad..3c1ecd5 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1631,8 +1631,10 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
-		printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl %x, fix "
-				"your userspace\n", current->comm, cmd);
+		if (printk_ratelimit())
+			printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl "
+					"%x (GET_MAJOR), fix your userspace\n",
+					current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
-- 
1.5.6.2

