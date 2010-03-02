Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0CBXte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:49:34 -0500
Received: from kroah.org ([198.145.64.141]:51612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0CBXhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/36] Char: synclink, remove unnecessary checks
Date: Tue,  2 Mar 2010 15:36:26 -0800
Message-Id: <1267573003-782-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

Stanse found a potential null dereference in mgsl_put_char and
mgsl_write. There is a check for tty being NULL, but it is
dereferenced earlier.

Actually, tty cannot be NULL in .write and .put_char, so remove
the tests.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

