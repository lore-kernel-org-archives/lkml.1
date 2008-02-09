Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYBINhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYBINhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbYBINf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:60464 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbYBINf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:27 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Tom Rini <trini@kernel.crashing.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/8] kgdb, sysrq_bugfix
Date: Sat,  9 Feb 2008 07:35:12 -0600
Message-Id: <1202564114-18587-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:57.0805 (UTC) FILETIME=[8FEFEBD0:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

It is possible that when SysRq-G is triggered via the keyboard that we
will miss the "up" event and once KGDB lets the kernel go another
SysRq will be required to clear this, without this change.

Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/keyboard.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 4dbd342..b79812e 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1190,6 +1190,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 		sysrq_down = 0;
 	if (sysrq_down && down && !rep) {
 		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
+		sysrq_down = 0;		/* In case we miss the 'up' event. */
 		return;
 	}
 #endif
-- 
1.5.4

