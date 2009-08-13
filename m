Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZHMEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZHMEmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZHMEmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:42:23 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47415 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751512AbZHMEmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:42:22 -0400
Subject: [PATCH][RT] pty low latency
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Novell
Date: Wed, 12 Aug 2009 21:42:17 -0700
Message-Id: <1250138537.15796.18.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: add hunks dropped in rt 2.6.31-rc5-rt1.1 forward port
From: patch-2.6.31-rc4-rt1
Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -52,6 +52,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 		return;
 	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
+	tty_flip_buffer_push(tty->link);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
@@ -207,6 +208,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
+	tty->low_latency = 1;
 out:
 	return retval;
 }


