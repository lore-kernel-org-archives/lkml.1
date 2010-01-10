Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868Ab0AJLaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0AJLaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 06:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896Ab0AJLaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 06:30:20 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:57628 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0AJLaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 06:30:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] Char: synclink, remove unnecessary checks
Date: Sun, 10 Jan 2010 12:30:16 +0100
Message-Id: <1263123016-19908-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <4B49B895.1060507@gmail.com>
References: <4B49B895.1060507@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential null dereference in mgsl_put_char and
mgsl_write. There is a check for tty being NULL, but it is
dereferenced earlier.

Actually, tty cannot be NULL in .write and .put_char, so remove
the tests.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/char/synclink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 4846b73..0658fc5 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2031,7 +2031,7 @@ static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
 		return 0;
 
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		return 0;
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
@@ -2121,7 +2121,7 @@ static int mgsl_write(struct tty_struct * tty,
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_write"))
 		goto cleanup;
 
-	if (!tty || !info->xmit_buf)
+	if (!info->xmit_buf)
 		goto cleanup;
 
 	if ( info->params.mode == MGSL_MODE_HDLC ||
-- 
1.6.5.7

