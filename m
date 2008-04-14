Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbYDNSoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbYDNSoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764055AbYDNSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41521 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763981AbYDNSmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:25 -0400
Date: Mon, 14 Apr 2008 21:40:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make init/do_mounts.c:root_device_name static
Message-ID: <20080414184044.GD6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global root_device_name static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 1 Mar 2008

 init/do_mounts.c |    2 +-
 init/do_mounts.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

eab4ea6c40eb148a52a4cbbb8523b203a379c20c foobar
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..56e3b17 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -22,7 +22,7 @@
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;
-char * __initdata root_device_name;
+static char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
 static int __initdata root_wait;
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index 735705d..9aa968d 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -11,7 +11,6 @@ void  change_floppy(char *fmt, ...);
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
 extern int root_mountflags;
-extern char *root_device_name;
 
 static inline int create_dev(char *name, dev_t dev)
 {

