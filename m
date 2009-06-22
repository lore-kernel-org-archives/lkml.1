Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZFVQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZFVQoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZFVQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37494 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755669AbZFVQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/15] vt_ioctl: fix lock imbalance
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:18 +0100
Message-ID: <20090622174215.25341.97384.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Don't return from switch/case directly in vt_ioctl. Set ret and break
instead so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
---

 drivers/char/vt_ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index e6ce632..7539bed 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -396,7 +396,8 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	kbd = kbd_table + console;
 	switch (cmd) {
 	case TIOCLINUX:
-		return tioclinux(tty, arg);
+		ret = tioclinux(tty, arg);
+		break;
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;

