Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZGMNn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZGMNn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZGMNn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:43:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840AbZGMNnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:43:55 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] fsnotify: use def_bool in kconfig instead of letting the
	user choose
To: linux-kernel@vger.kernel.org
Cc: scott@ubuntu.com, viro@ZenIV.linux.org.uk
Date: Mon, 13 Jul 2009 09:43:53 -0400
Message-ID: <20090713134353.14487.93035.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify doens't give the user anything.  If someone chooses inotify or
dnotify it should build fsnotify, if they don't select one it shouldn't be
built.  This patch changes fsnotify to be a def_bool=n and makes everything
else select it.  Also fixes the issue people complained about on lwn where
gdm hung because they didn't have inotify and they didn't get the inotify
build option.....

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Kconfig         |   12 +-----------
 fs/notify/dnotify/Kconfig |    2 +-
 fs/notify/inotify/Kconfig |    2 +-
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/notify/Kconfig b/fs/notify/Kconfig
index 31dac7e..dffbb09 100644
--- a/fs/notify/Kconfig
+++ b/fs/notify/Kconfig
@@ -1,15 +1,5 @@
 config FSNOTIFY
-	bool "Filesystem notification backend"
-	default y
-	---help---
-	   fsnotify is a backend for filesystem notification.  fsnotify does
-	   not provide any userspace interface but does provide the basis
-	   needed for other notification schemes such as dnotify, inotify,
-	   and fanotify.
-
-	   Say Y here to enable fsnotify suport.
-
-	   If unsure, say Y.
+	def_bool n
 
 source "fs/notify/dnotify/Kconfig"
 source "fs/notify/inotify/Kconfig"
diff --git a/fs/notify/dnotify/Kconfig b/fs/notify/dnotify/Kconfig
index 904ff8d..f9c1ca1 100644
--- a/fs/notify/dnotify/Kconfig
+++ b/fs/notify/dnotify/Kconfig
@@ -1,6 +1,6 @@
 config DNOTIFY
 	bool "Dnotify support"
-	depends on FSNOTIFY
+	select FSNOTIFY
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 5356884..3e56dbf 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -15,7 +15,7 @@ config INOTIFY
 
 config INOTIFY_USER
 	bool "Inotify support for userspace"
-	depends on FSNOTIFY
+	select FSNOTIFY
 	default y
 	---help---
 	  Say Y here to enable inotify support for userspace, including the

