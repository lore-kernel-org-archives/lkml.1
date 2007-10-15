Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbXJOSlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbXJOSlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933909AbXJOSeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:47909 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765628AbXJOSe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:26 -0400
Message-ID: <4713B286.7030100@windriver.com>
Date: Mon, 15 Oct 2007 13:33:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] KGDB: Fix possibility of missing SysRq-G 
Content-Type: multipart/mixed;
 boundary="------------060707060302020109070103"
X-OriginalArrivalTime: 15 Oct 2007 18:34:26.0047 (UTC) FILETIME=[038350F0:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060707060302020109070103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------060707060302020109070103
Content-Type: text/x-patch;
 name="sysrq_bugfix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sysrq_bugfix.patch"

sysrq_bugfix.patch

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] Fix possibility of missing SysRq-G 

It is possible that when SysRq-G is triggered via the keyboard that we
will miss the "up" event and once KGDB lets the kernel go another
SysRq will be required to clear this, without this change.

Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/keyboard.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21.1/drivers/char/keyboard.c
===================================================================
--- linux-2.6.21.1.orig/drivers/char/keyboard.c
+++ linux-2.6.21.1/drivers/char/keyboard.c
@@ -1176,6 +1176,7 @@ static void kbd_keycode(unsigned int key
 		sysrq_down = 0;
 	if (sysrq_down && down && !rep) {
 		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
+		sysrq_down = 0;		/* In case we miss the 'up' event. */
 		return;
 	}
 #endif

--------------060707060302020109070103--
