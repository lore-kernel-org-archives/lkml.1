Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZBAWoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZBAWoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBAWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:43:54 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:40415 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZBAWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:43:53 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] TTY: pty, lookup retval fixup
Date: Sun,  1 Feb 2009 23:43:47 +0100
Message-Id: <1233528227-12339-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090201230931.6f154044@the-village.bc.nu>
References: <20090201230931.6f154044@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we fail on NULL return value possibly returned by
master tty lookup.

Convert NULL to ERR_PTR(-ENODEV) in ptm_unix98_lookup, since NULL
is not captured by IS_ERR() in __tty_open.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/pty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 31038a0..261223b 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -508,7 +508,7 @@ static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver,
 	struct tty_struct *tty = devpts_get_tty(ptm_inode, idx);
 	if (tty)
 		tty = tty->link;
-	return tty;
+	return tty ? : ERR_PTR(-ENODEV);
 }
 
 /**
-- 
1.6.1.2

