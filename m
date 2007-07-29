Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbXG2PRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbXG2PRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765419AbXG2PCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:02:43 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47924 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764996AbXG2PCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:02:42 -0400
Date: Sun, 29 Jul 2007 17:02:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] allow disabling DNOTIFY without EMBEDDED
Message-ID: <20070729150219.GV16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows disabling DNOTIFY with CONFIG_EMBEDDED=n.

I'm currently running a kernel with dnotify disabled and I haven't run 
into any problem. Is there any popular application left that breaks 
without dnotify support in the kernel?

Note that this patch does not remove dnotify support, it still defaults
to "y", and the help text recommends enabling it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 1 Jul 2007
- 22 Jun 2007

--- linux-2.6.22-rc4-mm2/fs/Kconfig.old	2007-06-21 18:25:20.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/Kconfig	2007-06-21 18:25:54.000000000 +0200
@@ -585,17 +585,17 @@
 	depends on XFS_QUOTA || QUOTA
 	default y
 
 config DNOTIFY
-	bool "Dnotify support" if EMBEDDED
+	bool "Dnotify support"
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
 	  that uses signals to communicate events to user-space.  There exist
 	  superior alternatives, but some applications may still rely on
 	  dnotify.
 
-	  Because of this, if unsure, say Y.
+	  If unsure, say Y.
 
 config AUTOFS_FS
 	tristate "Kernel automounter support"
 	help

