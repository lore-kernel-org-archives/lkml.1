Return-Path: <linux-kernel-owner+w=401wt.eu-S1765585AbXGQOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765585AbXGQOTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763959AbXGQOIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35931 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760972AbXGQOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/33] kbuild: add support for squashing uid/gid in gen_initramfs_list.sh
Date: Tue, 17 Jul 2007 16:08:38 +0200
Message-Id: <11846813432249-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1184681343412-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Sometimes it is useful to squash all uid's/gid's to 0:0 regardless of
current owner.  For example, in build systems that get run as arbitrary
users (uClinux-dist).  This adds a special "squash" keyword so you can do
'-g squash -u squash' and have ownership squashed to root.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/gen_initramfs_list.sh |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 683eb12..684fb9c 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -19,11 +19,11 @@ $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	-o <file>      Create gzipped initramfs file named <file> using
 		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-		       <uid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <uid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to uid 0.
 	-g <gid>       Group ID to map to group ID 0 (root).
-		       <gid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <gid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to gid 0.
 	<cpio_source>  File list or directory for cpio archive.
 		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
@@ -113,8 +113,8 @@ parse() {
 	local gid="$4"
 	local ftype=$(filetype "${location}")
 	# remap uid/gid to 0 if necessary
-	[ "$uid" -eq "$root_uid" ] && uid=0
-	[ "$gid" -eq "$root_gid" ] && gid=0
+	[ "$root_uid" = "squash" ] && uid=0 || [ "$uid" -eq "$root_uid" ] && uid=0
+	[ "$root_gid" = "squash" ] && gid=0 || [ "$gid" -eq "$root_gid" ] && gid=0
 	local str="${mode} ${uid} ${gid}"
 
 	[ "${ftype}" == "invalid" ] && return 0
-- 
1.5.0.6

