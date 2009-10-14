Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbZJNXz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbZJNXz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbZJNXzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:55:25 -0400
Received: from kroah.org ([198.145.64.141]:38300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762191AbZJNXzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:55:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andreas Schwab <schwab@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] tty: fix vt_compat_ioctl
Date: Wed, 14 Oct 2009 16:52:08 -0700
Message-Id: <1255564328-9628-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <20091014230442.GD8865@kroah.com>
References: <20091014230442.GD8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@linux-m68k.org>

Call compat_unimap_ioctl, not do_unimap_ioctl.

This was broken by commit e9216651.

The compat_unimap_ioctl was originally called do_unimap_ioctl in
fs/compat_ioctl.h which got moved to drivers/char/vt_ioctl.c.
In that patch, the caller was not updated and consequently called
the native handler.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6b36ee5..ed86d3b 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1532,7 +1532,7 @@ long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		ret = do_unimap_ioctl(cmd, up, perm, vc);
+		ret = compat_unimap_ioctl(cmd, up, perm, vc);
 		break;
 
 	/*
-- 
1.6.4.2

