Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbXKERI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbXKERI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbXKERGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:06:43 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59472 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757255AbXKERGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:06:41 -0500
Date: Mon, 5 Nov 2007 18:06:18 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove Documentation/highuid.txt
Message-ID: <20071105170618.GX12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A nearly 8 years old status and TODO list for the change to 32-bit UIDs
doesn't have much value.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/00-INDEX    |    2 
 Documentation/highuid.txt |   79 --------------------------------------
 2 files changed, 81 deletions(-)

75431baf33dfc60d0e005fc09be529b6dacd595c 
diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 6b09461..9e94065 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -160,8 +160,6 @@ gpio.txt
 	- overview of GPIO (General Purpose Input/Output) access conventions.
 hayes-esp.txt
 	- info on using the Hayes ESP serial driver.
-highuid.txt
-	- notes on the change from 16 bit to 32 bit user/group IDs.
 hpet.txt
 	- High Precision Event Timer Driver for Linux.
 hrtimer/
diff --git a/Documentation/highuid.txt b/Documentation/highuid.txt
deleted file mode 100644
index 76034d9..0000000
--- a/Documentation/highuid.txt
+++ /dev/null
@@ -1,79 +0,0 @@
-Notes on the change from 16-bit UIDs to 32-bit UIDs:
-
-- kernel code MUST take into account __kernel_uid_t and __kernel_uid32_t
-  when communicating between user and kernel space in an ioctl or data
-  structure.
-
-- kernel code should use uid_t and gid_t in kernel-private structures and
-  code.
-
-What's left to be done for 32-bit UIDs on all Linux architectures:
-
-- Disk quotas have an interesting limitation that is not related to the
-  maximum UID/GID. They are limited by the maximum file size on the
-  underlying filesystem, because quota records are written at offsets
-  corresponding to the UID in question.
-  Further investigation is needed to see if the quota system can cope
-  properly with huge UIDs. If it can deal with 64-bit file offsets on all 
-  architectures, this should not be a problem.
-
-- Decide whether or not to keep backwards compatibility with the system
-  accounting file, or if we should break it as the comments suggest
-  (currently, the old 16-bit UID and GID are still written to disk, and
-  part of the former pad space is used to store separate 32-bit UID and
-  GID)
-
-- Need to validate that OS emulation calls the 16-bit UID
-  compatibility syscalls, if the OS being emulated used 16-bit UIDs, or
-  uses the 32-bit UID system calls properly otherwise.
-
-  This affects at least:
-	SunOS emulation
-	Solaris emulation
-	iBCS on Intel
-
-	sparc32 emulation on sparc64
-	(need to support whatever new 32-bit UID system calls are added to
-	sparc32)
-
-- Validate that all filesystems behave properly.
-
-  At present, 32-bit UIDs _should_ work for:
-	ext2
-	ufs
-	isofs
-	nfs
-	coda
-	udf
-
-  Ioctl() fixups have been made for:
-	ncpfs
-	smbfs
-
-  Filesystems with simple fixups to prevent 16-bit UID wraparound:
-	minix
-	sysv
-	qnx4
-
-  Other filesystems have not been checked yet.
-
-- The ncpfs and smpfs filesystems cannot presently use 32-bit UIDs in
-  all ioctl()s. Some new ioctl()s have been added with 32-bit UIDs, but
-  more are needed. (as well as new user<->kernel data structures)
-
-- The ELF core dump format only supports 16-bit UIDs on arm, i386, m68k,
-  sh, and sparc32. Fixing this is probably not that important, but would
-  require adding a new ELF section.
-
-- The ioctl()s used to control the in-kernel NFS server only support
-  16-bit UIDs on arm, i386, m68k, sh, and sparc32.
-
-- make sure that the UID mapping feature of AX25 networking works properly
-  (it should be safe because it's always used a 32-bit integer to
-  communicate between user and kernel)
-
-
-Chris Wing
-wingc@umich.edu
-
-last updated: January 11, 2000

