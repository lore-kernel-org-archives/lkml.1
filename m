Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYK2Wl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYK2Wl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYK2WlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:41:24 -0500
Received: from gimli.pxnet.com ([195.227.45.7]:37772 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYK2WlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:41:23 -0500
Message-Id: <9b6d85e917139005e83f6b93460d71c4220cc880.1227876791.git.tilman@imap.cc>
In-Reply-To: <1227876791.git.tilman@imap.cc>
References: <1227876791.git.tilman@imap.cc>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 1/2] gigaset: remove unnecessary poll method
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Sat, 29 Nov 2008 23:41:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The N_GIGASET_M101 line discipline implemented by the ser_gigaset
driver does not transfer any data from/to userspace through the
tty interface. Therefore a poll method is not needed.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/ser-gigaset.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 07052ed..0b8c8f2 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -16,7 +16,6 @@
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 #include <linux/tty.h>
-#include <linux/poll.h>
 #include <linux/completion.h>
 
 /* Version Information */
@@ -571,7 +570,6 @@ gigaset_tty_close(struct tty_struct *tty)
 	}
 
 	/* prevent other callers from entering ldisc methods */
-	/* FIXME: should use the tty state flags */
 	tty->disc_data = NULL;
 
 	if (!cs->hw.ser)
@@ -673,18 +671,6 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
 }
 
 /*
- * Poll on the tty.
- * Unused, always return zero.
- *
- * FIXME: should probably return an exception - especially on hangup
- */
-static unsigned int
-gigaset_tty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
-{
-	return 0;
-}
-
-/*
  * Called by the tty driver when a block of data has been received.
  * Will not be re-entered while running but other ldisc functions
  * may be called in parallel.
@@ -773,7 +759,6 @@ static struct tty_ldisc_ops gigaset_ldisc = {
 	.read		= gigaset_tty_read,
 	.write		= gigaset_tty_write,
 	.ioctl		= gigaset_tty_ioctl,
-	.poll		= gigaset_tty_poll,
 	.receive_buf	= gigaset_tty_receive,
 	.write_wakeup	= gigaset_tty_wakeup,
 };
-- 
1.6.0.1.100.gcb138

