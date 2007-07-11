Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXGKS0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXGKS0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760389AbXGKSZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:25:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58315 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760162AbXGKSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:25:35 -0400
Date: Wed, 11 Jul 2007 20:26:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] ANON_INODES shouldn't be user visible
Message-ID: <20070711182607.GM3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be a good reason for ANON_INODES being
an user visible option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 init/Kconfig |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc6-mm1/init/Kconfig.old	2007-07-11 06:34:48.000000000 +0200
+++ linux-2.6.22-rc6-mm1/init/Kconfig	2007-07-11 06:35:21.000000000 +0200
@@ -525,25 +525,19 @@
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anonymous inode source" if EMBEDDED
-	default y
-	help
-	  Anonymous inode source for pseudo-files like epoll, signalfd,
-	  timerfd and eventfd.
-
-	  If unsure, say Y.
+	bool
 
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
-	depends on ANON_INODES
+	select ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
 config SIGNALFD
 	bool "Enable signalfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the signalfd() system call that allows to receive signals
@@ -553,7 +547,7 @@
 
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
@@ -563,7 +557,7 @@
 
 config EVENTFD
 	bool "Enable eventfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the eventfd() system call that allows to receive both

