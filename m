Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbYHWCd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbYHWCd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 22:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYHWCdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 22:33:47 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:42361 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbYHWCdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 22:33:47 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Bart Trojanowski <bart@jukie.net>
Cc: linux-kernel@vger.kernel.org, Bart Trojanowski <bart@jukie.net>,
       trivial@kernel.org, hirofumi@mail.parknet.co.jp
Subject: Re: [PATCH] document additional vfat mount options
Date: Sat, 23 Aug 2008 12:33:16 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <sktua4ta7e0jspqnsbd3fqveb204togekh@4ax.com>
References: <20080820022712.GF28029@jukie.net> <1219452859-24960-1-git-send-email-bart@jukie.net>
In-Reply-To: <1219452859-24960-1-git-send-email-bart@jukie.net>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 20:54:19 -0400, Bart Trojanowski <bart@jukie.net> wrote:

>While debugging a sync mount regression on vfat I noticed that there
>were mount options parsed by the driver that were not documented.
>
>Signed-off-by: Bart Trojanowski <bart@jukie.net>
>Cc: trivial@kernel.org
>Cc: hirofumi@mail.parknet.co.jp
>---
> Documentation/filesystems/vfat.txt |   31 +++++++++++++++++++++++++++++--
> 1 files changed, 29 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
>index bbac4f1..4e26744 100644
>--- a/Documentation/filesystems/vfat.txt
>+++ b/Documentation/filesystems/vfat.txt
>@@ -8,6 +8,14 @@ if you want to format from within Linux.
> 
> VFAT MOUNT OPTIONS
> ----------------------------------------------------------------------
>+uid=###       -- Explicitly set ownership of all files on this
>+                 filesystem to this user ID number.  Default is to use
>+                 the UID of the mounting process.
>+
>+gid=###       -- Explisitly set ownership of all files on thsi
							    ^^^^
>+                 filesystem to this group ID number.  Default is to use
>+                 the GID of the mounting process.
>+
> umask=###     -- The permission mask (for files and directories, see umask(1)).
>                  The default is the umask of current process.
> 
>@@ -36,7 +44,7 @@ codepage=###  -- Sets the codepage number for converting to shortname
> 		 characters on FAT filesystem.
> 		 By default, FAT_DEFAULT_CODEPAGE setting is used.
> 
>-iocharset=name -- Character set to use for converting between the
>+iocharset=<name> -- Character set to use for converting between the
> 		 encoding is used for user visible filename and 16 bit
> 		 Unicode characters. Long filenames are stored on disk
> 		 in Unicode format, but Unix for the most part doesn't
>@@ -86,6 +94,10 @@ check=s|r|n   -- Case sensitivity checking setting.
>                  r: relaxed, case insensitive
>                  n: normal, default setting, currently case insensitive
> 
>+nocase        -- If set, files and directories read from device will have
>+                 their names converted to lowercase.  Not set by
>+                 default.
>+
> shortname=lower|win95|winnt|mixed
> 	      -- Shortname display/create setting.
> 		 lower: convert to lowercase for display,
>@@ -99,11 +111,26 @@ shortname=lower|win95|winnt|mixed
> tz=UTC        -- Interpret timestamps as UTC rather than local time.
>                  This option disables the conversion of timestamps
>                  between local time (as used by Windows on FAT) and UTC
>-                 (which Linux uses internally).  This is particuluarly
>+                 (which Linux uses internally).  This is particularly
>                  useful when mounting devices (like digital cameras)
>                  that are set to UTC in order to avoid the pitfalls of
>                  local time.
> 
>+showexec      -- If set, files that end if .EXE, .COM, or .BAT will have
>+                 the execute permission bits set.  Not set by default,
>+                 in which case all files show up with the execute bits set.
>+
>+debug         -- Can be set, but unused by the current implementation.
>+
>+sys_immutable -- If set, all files on this filesystem which have the SYS
>+                 attribute (DOS bit) set will become IMMUTABLE (inode flag)
>+                 preventing write operations on these files.  Not set by
>+                 default.
>+
>+flush         -- If set, modified inodes will be flushed to disk on file
>+                 close system call.  This is ideal for USB connected
>+                 devices.  Not set by default.
>+
> <bool>: 0,1,yes,no,true,false
> 
> TODO
>-- 
>1.6.0.rc0.43.gb0a469

