Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbYJMKJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbYJMKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbYJMJq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:46:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32932 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761155AbYJMJq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:46:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 80/80] tty: rename the remaining oddly named n_tty functions
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:46:24 +0100
Message-ID: <20081013094614.21645.47732.stgit@localhost.localdomain>
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

Original idea for this from a patch by Rodolfo Giometti which merges various
bits of PPS support

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/n_tty.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index c0285b9..efbfe96 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -26,7 +26,7 @@
  *
  * 2002/03/18   Implemented n_tty_wakeup to send SIGIO POLL_OUTs to
  *		waiting writing processes-Sapan Bhatia <sapan@corewars.org>.
- *		Also fixed a bug in BLOCKING mode where write_chan returns
+ *		Also fixed a bug in BLOCKING mode where n_tty_write returns
  *		EAGAIN
  */
 
@@ -358,7 +358,7 @@ static int opost(unsigned char c, struct tty_struct *tty)
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock. Relies
+ *	Called from n_tty_write under the tty layer write lock. Relies
  *	on lock_kernel for the tty->column state.
  */
 
@@ -1183,7 +1183,7 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
  *	@b: user data
  *	@nr: size of data
  *
- *	Helper function to speed up read_chan.  It is only called when
+ *	Helper function to speed up n_tty_read.  It is only called when
  *	ICANON is off; it copies characters straight from the tty queue to
  *	user space directly.  It can be profitably called twice; once to
  *	drain the space from the tail pointer to the (physical) end of the
@@ -1250,7 +1250,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
 	if (file->f_op->write != redirected_tty_write &&
 	    current->signal->tty == tty) {
 		if (!tty->pgrp)
-			printk(KERN_ERR "read_chan: no tty->pgrp!\n");
+			printk(KERN_ERR "n_tty_read: no tty->pgrp!\n");
 		else if (task_pgrp(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
 			    is_current_pgrp_orphaned())
@@ -1265,7 +1265,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
 
 
 /**
- *	read_chan		-	read function for tty
+ *	n_tty_read		-	read function for tty
  *	@tty: tty device
  *	@file: file object
  *	@buf: userspace buffer pointer
@@ -1279,7 +1279,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
  *	This code must be sure never to sleep through a hangup.
  */
 
-static ssize_t read_chan(struct tty_struct *tty, struct file *file,
+static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			 unsigned char __user *buf, size_t nr)
 {
 	unsigned char __user *b = buf;
@@ -1481,7 +1481,7 @@ do_it_again:
 }
 
 /**
- *	write_chan		-	write function for tty
+ *	n_tty_write		-	write function for tty
  *	@tty: tty device
  *	@file: file object
  *	@buf: userspace buffer pointer
@@ -1495,7 +1495,7 @@ do_it_again:
  *	This code must be sure never to sleep through a hangup.
  */
 
-static ssize_t write_chan(struct tty_struct *tty, struct file *file,
+static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			  const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
@@ -1569,7 +1569,7 @@ break_out:
 }
 
 /**
- *	normal_poll		-	poll method for N_TTY
+ *	n_tty_poll		-	poll method for N_TTY
  *	@tty: terminal device
  *	@file: file accessing it
  *	@wait: poll table
@@ -1582,7 +1582,7 @@ break_out:
  *	Called without the kernel lock held - fine
  */
 
-static unsigned int normal_poll(struct tty_struct *tty, struct file *file,
+static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 							poll_table *wait)
 {
 	unsigned int mask = 0;
@@ -1655,11 +1655,11 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.close           = n_tty_close,
 	.flush_buffer    = n_tty_flush_buffer,
 	.chars_in_buffer = n_tty_chars_in_buffer,
-	.read            = read_chan,
-	.write           = write_chan,
+	.read            = n_tty_read,
+	.write           = n_tty_write,
 	.ioctl           = n_tty_ioctl,
 	.set_termios     = n_tty_set_termios,
-	.poll            = normal_poll,
+	.poll            = n_tty_poll,
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };

