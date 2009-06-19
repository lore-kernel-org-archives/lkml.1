Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZFSVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZFSVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZFSVIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:08:46 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:44767 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZFSVIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:08:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/3] Char: vt_ioctl, fix lock imbalance
Date: Fri, 19 Jun 2009 23:08:28 +0200
Message-Id: <1245445708-27256-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245445708-27256-1-git-send-email-jirislaby@gmail.com>
References: <1245445708-27256-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return from switch/case directly in vt_ioctl. Set ret and break
instead so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/vt_ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index e6ce632..7539bed 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -396,7 +396,8 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	kbd = kbd_table + console;
 	switch (cmd) {
 	case TIOCLINUX:
-		return tioclinux(tty, arg);
+		ret = tioclinux(tty, arg);
+		break;
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;
-- 
1.6.3.2

