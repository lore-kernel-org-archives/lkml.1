Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZI1SKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZI1SKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZI1SKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:10:03 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:54029 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZI1SKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:10:02 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix vt_compat_ioctl
CC: Greg Kroah-Hartman <gregkh@suse.de>
X-Yow: ..  My pants just went on a wild rampage through
 a Long Island Bowling Alley!!
Date: Mon, 28 Sep 2009 20:10:02 +0200
Message-ID: <m2y6nzgcud.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call compat_unimap_ioctl, not do_unimap_ioctl.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 drivers/char/vt_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 29c651a..431c5c3 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1530,7 +1530,7 @@ long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		ret = do_unimap_ioctl(cmd, up, perm, vc);
+		ret = compat_unimap_ioctl(cmd, up, perm, vc);
 		break;
 
 	/*
-- 
1.6.4.4

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
