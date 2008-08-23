Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYHWOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYHWOrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 10:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYHWOrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 10:47:15 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42805 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYHWOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 10:47:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Bart Trojanowski <bart@jukie.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] document additional vfat mount options
References: <20080823031229.GA28029@jukie.net>
	<1219461278-26776-1-git-send-email-bart@jukie.net>
	<87tzdcfm2g.fsf@devron.myhome.or.jp>
	<20080823131131.GE28029@jukie.net>
Date: Sat, 23 Aug 2008 23:47:08 +0900
In-Reply-To: <20080823131131.GE28029@jukie.net> (Bart Trojanowski's message of
	"Sat, 23 Aug 2008 09:11:31 -0400")
Message-ID: <87bpzj94b7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski <bart@jukie.net> writes:

> * OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> [080822 23:27]:
>> Thanks. Fixed. Current patch is the following.
>
> Indeed, I have made some mistakes.
>
> Now that I read it again...
>
>> +gid=###       -- Explisitly set ownership of all files on this
>> +                 filesystem to this group ID number.  Default is to use
>> +                 the GID of the mounting process.
>
> ... it has a 'explicit' typo, spotted by Ian Ward, and it's not setting
> ownership, but rather group ownership.  So how about this
>
> gid=###       -- Explicitly set group ownership of all files on this
>                  filesystem to this group ID number.  Default is to use
>                  the GID of the mounting process.

Looks good. However, I've noticed manpage's one may be simpler and
consistent. So, the updated patch is following.

If you found something wrong, please let me know.  Thanks
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


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
--- linux-2.6/Documentation/filesystems/vfat.txt~fat-doc-fixes	2008-08-23 12:15:06.000000000 +0900
+++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2008-08-23 23:38:32.000000000 +0900
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
