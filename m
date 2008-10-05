Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbYJEQeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbYJEQeo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbYJEQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:25:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34345 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758652AbYJEQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:25:22 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 74/76] tty: tty_io.c shadows sparse fix
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:25:23 +0100
Message-ID: <20081005162454.1997.78278.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

drivers/char/tty_io.c:1413:17: warning: symbol 'buf' shadows an earlier one
drivers/char/tty_io.c:1379:20: originally declared here

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 502cad6..7053d63 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1026,19 +1026,19 @@ static inline ssize_t do_tty_write(
 
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

