Return-Path: <linux-kernel-owner+w=401wt.eu-S1763777AbYJMJs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777AbYJMJs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYJMJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:39:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48664 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760401AbYJMJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:39:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 41/80] tty: compare the tty winsize
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:39:01 +0100
Message-ID: <20081013093852.21645.5063.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

We always use the real tty one for stuff so the pty one should not be
compared. As we propogate window changes to both it doesn't currently
matter but will when we tidy up the pty termios logic a bit more

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index ac53d7f..9a76db3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2133,7 +2133,7 @@ int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 
 	/* For a PTY we need to lock the tty side */
 	mutex_lock(&real_tty->termios_mutex);
-	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
+	if (!memcmp(ws, &real_tty->winsize, sizeof(*ws)))
 		goto done;
 	/* Get the PID values and reference them so we can
 	   avoid holding the tty ctrl lock while sending signals */

