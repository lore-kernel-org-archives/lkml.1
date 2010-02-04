Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539Ab0BDRdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:33:18 -0500
Received: from kroah.org ([198.145.64.141]:34689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139Ab0BDRVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:49 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:03 2010
Message-Id: <20100204171503.249043660@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [26/74] fix affs parse_options()
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 217686e98321a4ff4c1a6cc535e511e37c5d2dbf upstream.

Error handling in that sucker got broken back in 2003.  If function
returns 0 on failure, it's not nice to add return -EINVAL into it.
Adding return 1 on other failure exits is also not a good thing (and
yes, original success exits with 1 and some of failure exits with 0
are still there; so's the original logics in callers).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/affs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -203,7 +203,7 @@ parse_options(char *options, uid_t *uid,
 		switch (token) {
 		case Opt_bs:
 			if (match_int(&args[0], &n))
-				return -EINVAL;
+				return 0;
 			if (n != 512 && n != 1024 && n != 2048
 			    && n != 4096) {
 				printk ("AFFS: Invalid blocksize (512, 1024, 2048, 4096 allowed)\n");
@@ -213,7 +213,7 @@ parse_options(char *options, uid_t *uid,
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
-				return 1;
+				return 0;
 			*mode = option & 0777;
 			*mount_opts |= SF_SETMODE;
 			break;
@@ -231,21 +231,21 @@ parse_options(char *options, uid_t *uid,
 			break;
 		case Opt_reserved:
 			if (match_int(&args[0], reserved))
-				return 1;
+				return 0;
 			break;
 		case Opt_root:
 			if (match_int(&args[0], root))
-				return 1;
+				return 0;
 			break;
 		case Opt_setgid:
 			if (match_int(&args[0], &option))
-				return 1;
+				return 0;
 			*gid = option;
 			*mount_opts |= SF_SETGID;
 			break;
 		case Opt_setuid:
 			if (match_int(&args[0], &option))
-				return -EINVAL;
+				return 0;
 			*uid = option;
 			*mount_opts |= SF_SETUID;
 			break;


