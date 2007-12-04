Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXLDWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXLDWBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXLDWBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:01:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14431 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbXLDWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:01:22 -0500
Message-Id: <20071204215003.291002606@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 04 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/3] drivers/char/tty_io.c: remove pty_sem
Message-Id: <20071204214954.656363725@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com
Content-Disposition: inline; filename=remove-pty_sem-from-tty_bufhead.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't find any users, so removing it..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/tty_io.c |    1 -
 include/linux/tty.h   |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6.23/drivers/char/tty_io.c
===================================================================
--- linux-2.6.23.orig/drivers/char/tty_io.c
+++ linux-2.6.23/drivers/char/tty_io.c
@@ -3721,7 +3721,6 @@ static void initialize_tty_struct(struct
 	tty->buf.head = tty->buf.tail = NULL;
 	tty_buffer_init(tty);
 	INIT_DELAYED_WORK(&tty->buf.work, flush_to_ldisc);
-	init_MUTEX(&tty->buf.pty_sem);
 	mutex_init(&tty->termios_mutex);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
Index: linux-2.6.23/include/linux/tty.h
===================================================================
--- linux-2.6.23.orig/include/linux/tty.h
+++ linux-2.6.23/include/linux/tty.h
@@ -73,7 +73,6 @@ struct tty_buffer {
 
 struct tty_bufhead {
 	struct delayed_work work;
-	struct semaphore pty_sem;
 	spinlock_t lock;
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */

-- 
