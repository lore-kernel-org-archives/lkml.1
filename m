Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZKPA3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZKPA3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZKPA3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:29:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbZKPA1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 11/12] hamradio/mkiss: fix typo in compat_ioctl
Date: Mon, 16 Nov 2009 00:27:06 +0000
Message-Id: <1258331227-1694-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WGUv+wJjawnur9jQY2Lc+q+eApytSwnpf6ik
 Xpt8I5Mj1o2qBcb+E/lpgjvmLc7iH4Hxgt361IbbSHGeIgwAA1
 lHO14r3aen+TImGrjSCMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My last commit introduced an typo causing the
compat_ioctl function to do nothing useful.
The obvious way for an ioctl function to work
is to look at the command, not the argument first.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/hamradio/mkiss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index fc9c578..7db0a1c 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -903,7 +903,7 @@ static int mkiss_ioctl(struct tty_struct *tty, struct file *file,
 static long mkiss_compat_ioctl(struct tty_struct *tty, struct file *file,
 	unsigned int cmd, unsigned long arg)
 {
-	switch (arg) {
+	switch (cmd) {
 	case SIOCGIFNAME:
 	case SIOCGIFENCAP:
 	case SIOCSIFENCAP:
-- 
1.6.3.3

