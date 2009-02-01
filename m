Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbZBAVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbZBAVkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 16:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZBAVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 16:39:28 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:59984 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbZBAVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:27 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] TTY: tty_io, lookup retval fixup
Date: Sun,  1 Feb 2009 22:39:16 +0100
Message-Id: <1233524356-10994-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we fail on NULL return value possibly returned by pty
master lookup.

Convert NULL to ERR_PTR(-ENODEV), since NULL is not captured by
IS_ERR() in __tty_open.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/tty_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index ff92099..2c14dd8 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1217,7 +1217,8 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 	struct tty_struct *tty;
 
 	if (driver->ops->lookup)
-		return driver->ops->lookup(driver, inode, idx);
+		return driver->ops->lookup(driver, inode, idx) ? :
+			ERR_PTR(-ENODEV);
 
 	tty = driver->ttys[idx];
 	return tty;
-- 
1.6.1.2

