Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYJOOMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYJOOMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbYJOOGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:21 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32964 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYJOOGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:10 -0400
Subject: [PATCH 01/21] fat: document additional vfat mount options
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp, bart@jukie.net
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:55 +0900
Message-ID: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bart Trojanowski <bart@jukie.net>

While debugging a sync mount regression on vfat I noticed that there
were mount options parsed by the driver that were not documented.

[hirofumi@mail.parknet.co.jp: fix some parts]
Signed-off-by: Bart Trojanowski <bart@jukie.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 Documentation/filesystems/vfat.txt |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-doc-fixes Documentation/filesystems/vfat.txt
--- linux-2.6/Documentation/filesystems/vfat.txt~fat-doc-fixes	2008-08-24 22:47:00.000000000 +0900
+++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2008-08-24 22:47:00.000000000 +0900
@@ -8,6 +8,12 @@ if you want to format from within Linux.
 
 VFAT MOUNT OPTIONS
 ----------------------------------------------------------------------
+uid=###       -- Set the owner of all files on this filesystem.
+		 The default is the uid of current process.
+
+gid=###       -- Set the group of all files on this filesystem.
+		 The default is the gid of current process.
+
 umask=###     -- The permission mask (for files and directories, see umask(1)).
                  The default is the umask of current process.
 
@@ -36,7 +42,7 @@ codepage=###  -- Sets the codepage numbe
 		 characters on FAT filesystem.
 		 By default, FAT_DEFAULT_CODEPAGE setting is used.
 
-iocharset=name -- Character set to use for converting between the
+iocharset=<name> -- Character set to use for converting between the
 		 encoding is used for user visible filename and 16 bit
 		 Unicode characters. Long filenames are stored on disk
 		 in Unicode format, but Unix for the most part doesn't
@@ -86,6 +92,8 @@ check=s|r|n   -- Case sensitivity checki
                  r: relaxed, case insensitive
                  n: normal, default setting, currently case insensitive
 
+nocase        -- This was deprecated for vfat. Use shortname=win95 instead.
+
 shortname=lower|win95|winnt|mixed
 	      -- Shortname display/create setting.
 		 lower: convert to lowercase for display,
@@ -99,11 +107,23 @@ shortname=lower|win95|winnt|mixed
 tz=UTC        -- Interpret timestamps as UTC rather than local time.
                  This option disables the conversion of timestamps
                  between local time (as used by Windows on FAT) and UTC
-                 (which Linux uses internally).  This is particuluarly
+                 (which Linux uses internally).  This is particularly
                  useful when mounting devices (like digital cameras)
                  that are set to UTC in order to avoid the pitfalls of
                  local time.
 
+showexec      -- If set, the execute permission bits of the file will be
+		 allowed only if the extension part of the name is .EXE,
+		 .COM, or .BAT. Not set by default.
+
+debug         -- Can be set, but unused by the current implementation.
+
+sys_immutable -- If set, ATTR_SYS attribute on FAT is handled as
+		 IMMUTABLE flag on Linux. Not set by default.
+
+flush         -- If set, the filesystem will try to flush to disk more
+		 early than normal. Not set by default.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
_
