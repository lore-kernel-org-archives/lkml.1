Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZGKBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZGKBGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZGKBGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:06:32 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:61797 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZGKBGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:06:31 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A57E5A2.8060907@lwfinger.net>
Date: Fri, 10 Jul 2009 20:06:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: miklos@szeredi.hu, Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fuse: Fix build error
Content-Type: multipart/mixed;
 boundary="------------080404040802090708080409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080404040802090708080409
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building v2.6.31-rc2-344-g69ca06c, the following build errors are
found due to missing includes:

 CC [M]  fs/fuse/dev.o
fs/fuse/dev.c: In function ‘request_end’:
fs/fuse/dev.c:289: error: ‘BLK_RW_SYNC’ undeclared (first use in this
function)
fs/fuse/dev.c:289: error: (Each undeclared identifier is reported only
once
fs/fuse/dev.c:289: error: for each function it appears in.)
fs/fuse/dev.c:290: error: ‘BLK_RW_ASYNC’ undeclared (first use in this
function)
fs/fuse/dev.c: In function ‘fuse_request_send_nowait_locked’:
fs/fuse/dev.c:417: error: ‘BLK_RW_SYNC’ undeclared (first use in this
function)
fs/fuse/dev.c:418: error: ‘BLK_RW_ASYNC’ undeclared (first use in this
function)
make[2]: *** [fs/fuse/dev.o] Error 1

fs/nfs/write.c: In function ‘nfs_set_page_writeback’:
fs/nfs/write.c:207: error: ‘BLK_RW_ASYNC’ undeclared (first use in
this function)
fs/nfs/write.c:207: error: (Each undeclared identifier is reported
only once
fs/nfs/write.c:207: error: for each function it appears in.)
fs/nfs/write.c: In function ‘nfs_end_page_writeback’:
fs/nfs/write.c:220: error: ‘BLK_RW_ASYNC’ undeclared (first use in
this function)
  CC      lib/dump_stack.o
make[2]: *** [fs/nfs/write.o] Error 1

Signed-off-by: Larry Finger@lwfinger.net>
---

 fuse/dev.c  |    1 +
 nfs/write.c |    1 +
 2 files changed, 2 insertions(+)


Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c
+++ linux-2.6/fs/fuse/dev.c
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>

 MODULE_ALIAS_MISCDEV(FUSE_MINOR);

Index: linux-2.6/fs/nfs/write.c
===================================================================
--- linux-2.6.orig/fs/nfs/write.c
+++ linux-2.6/fs/nfs/write.c
@@ -19,6 +19,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>

 #include <asm/uaccess.h>




--------------080404040802090708080409
Content-Type: text/plain;
 name="fix_fuse_build"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="fix_fuse_build"

SW5kZXg6IGxpbnV4LTIuNi9mcy9mdXNlL2Rldi5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi5vcmlnL2ZzL2Z1c2UvZGV2LmMKKysrIGxpbnV4LTIuNi9mcy9mdXNlL2Rldi5jCkBA
IC0xNiw2ICsxNiw3IEBACiAjaW5jbHVkZSA8bGludXgvcGFnZW1hcC5oPgogI2luY2x1ZGUg
PGxpbnV4L2ZpbGUuaD4KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8bGlu
dXgvYmxrZGV2Lmg+CiAKIE1PRFVMRV9BTElBU19NSVNDREVWKEZVU0VfTUlOT1IpOwogCklu
ZGV4OiBsaW51eC0yLjYvZnMvbmZzL3dyaXRlLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgt
Mi42Lm9yaWcvZnMvbmZzL3dyaXRlLmMKKysrIGxpbnV4LTIuNi9mcy9uZnMvd3JpdGUuYwpA
QCAtMTksNiArMTksNyBAQAogI2luY2x1ZGUgPGxpbnV4L25mc19tb3VudC5oPgogI2luY2x1
ZGUgPGxpbnV4L25mc19wYWdlLmg+CiAjaW5jbHVkZSA8bGludXgvYmFja2luZy1kZXYuaD4K
KyNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KIAogI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+
CiAK
--------------080404040802090708080409--
