Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZFPPCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZFPPCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbZFPPCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:02:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44030 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757273AbZFPPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:02:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/9] ldisc: Make sure the ldisc isn't active when we close it
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:00:40 +0100
Message-ID: <20090616160031.10041.89329.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 94b3e06..874c248 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -793,6 +793,8 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		/* Avoid racing set_ldisc */
 		mutex_lock(&tty->ldisc_mutex);
 		/* Switch back to N_TTY */
+		tty_ldisc_halt(tty);
+		tty_ldisc_wait_idle(tty);
 		tty_ldisc_reinit(tty);
 		/* At this point we have a closed ldisc and we want to
 		   reopen it. We could defer this to the next open but

