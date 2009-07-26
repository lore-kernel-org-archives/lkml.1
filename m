Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZGZIWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZGZIWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZGZIWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:22:46 -0400
Received: from www.tglx.de ([62.245.132.106]:34013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZGZIWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:22:45 -0400
Message-Id: <20090726081553.506979599@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [Patch RFC 02/37] input: keyboard/hil_kbd: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=drivers-input-keyboard-hil-kbd-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/hil_kbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/input/keyboard/hil_kbd.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/keyboard/hil_kbd.c
+++ linux-2.6-tip/drivers/input/keyboard/hil_kbd.c
@@ -277,7 +277,7 @@ static int hil_kbd_connect(struct serio 
 	serio_set_drvdata(serio, kbd);
 	kbd->serio = serio;
 
-	init_MUTEX_LOCKED(&kbd->sem);
+	semaphore_init_locked(&kbd->sem);
 
 	/* Get device info.  MLC driver supplies devid/status/etc. */
 	serio->write(serio, 0);


