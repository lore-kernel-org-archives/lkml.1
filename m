Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYIZTsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYIZTsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIZTsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:48:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:35220 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYIZTsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:48:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: tty_io.c shadows sparse fix
Date: Fri, 26 Sep 2008 14:48:01 -0500
Message-Id: <1222458481-17466-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
X-OriginalArrivalTime: 26 Sep 2008 19:48:02.0355 (UTC) FILETIME=[C92DB030:01C92010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the problem reported by sparse:

drivers/char/tty_io.c:1413:17: warning: symbol 'buf' shadows an earlier one
drivers/char/tty_io.c:1379:20: originally declared here

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/tty_io.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index daeb8f7..a155002 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1410,19 +1410,19 @@ static inline ssize_t do_tty_write(
 
 	/* write_buf/write_cnt is protected by the atomic_write_lock mutex */
 	if (tty->write_cnt < chunk) {
-		unsigned char *buf;
+		unsigned char *buf_chunk;
 
 		if (chunk < 1024)
 			chunk = 1024;
 
-		buf = kmalloc(chunk, GFP_KERNEL);
-		if (!buf) {
+		buf_chunk = kmalloc(chunk, GFP_KERNEL);
+		if (!buf_chunk) {
 			ret = -ENOMEM;
 			goto out;
 		}
 		kfree(tty->write_buf);
 		tty->write_cnt = chunk;
-		tty->write_buf = buf;
+		tty->write_buf = buf_chunk;
 	}
 
 	/* Do the write .. */
-- 
1.6.0.90.g436ed.dirty

