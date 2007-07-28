Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXG1N1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXG1N1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXG1N1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:27:08 -0400
Received: from host-69-39-86-10.a2webhosting.com ([69.39.86.10]:33868 "EHLO
	a2s21.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXG1N1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:27:07 -0400
Message-ID: <46AB4436.5020207@banksresearch.com>
Date: Sat, 28 Jul 2007 09:27:18 -0400
From: Wyatt Banks <wyatt@banksresearch.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: document HFSPlus
References: <46AA9B1B.10206@banksresearch.com> <20070727194541.c37a0ba4.randy.dunlap@oracle.com>
In-Reply-To: <20070727194541.c37a0ba4.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-A2hosting-MailScanner-Information: Please contact the ISP for more information
X-A2hosting-MailScanner: Found to be clean
X-A2hosting-MailScanner-SpamCheck: 
X-A2hosting-MailScanner-From: wyatt@banksresearch.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s21.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - banksresearch.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> 
>> ---
>>
>> Patched against 2.6.22.1
> 
> FYI:  Patches should be against the latest -rc or -git (when
> available), but it probably doesn't matter in this case.
> 

Thanks for the tip and corrections.  Here's the latest.


From:	Wyatt Banks <wyatt@banksresearch.com>

Documentation: document HFSPlus filesystem and its mount options.

Signed-off-by:	Wyatt Banks <wyatt@banksresearch.com>

diff -uprN linux-2.6.23-rc1/Documentation/filesystems/hfsplus.txt linux-2.6.23-rc1-devel/Documentation/filesystems/hfsplus.txt
--- linux-2.6.23-rc1/Documentation/filesystems/hfsplus.txt	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.23-rc1-devel/Documentation/filesystems/hfsplus.txt	2007-07-28 09:14:46.000000000 -0400
@@ -0,0 +1,59 @@
+
+Macintosh HFSPlus Filesystem for Linux
+======================================
+
+HFSPlus is a filesystem first introduced in MacOS 8.1.
+HFSPlus has several extensions to HFS, including 32-bit allocation
+blocks, 255-character unicode filenames, and file sizes of 2^63 bytes.
+
+
+Mount options
+=============
+
+When mounting an HFSPlus filesystem, the following options are accepted:
+
+  creator=cccc, type=cccc
+	Specifies the creator/type values as shown by the MacOS finder
+	used for creating new files.  Default values: '????'.
+
+  uid=n, gid=n
+	Specifies the user/group that owns all files on the filesystem
+	that have uninitialized permissions structures.
+	Default:  user/group id of the mounting process.
+
+  umask=n
+	Specifies the umask (in octal) used for files and directories
+	that have uninitialized permissions structures.
+	Default:  umask of the mounting process.
+
+  session=n
+	Select the CDROM session to mount as HFSPlus filesystem.  Defaults to
+	leaving that decision to the CDROM driver.  This option will fail
+	with anything but a CDROM as underlying devices.
+
+  part=n
+	Select partition number n from the devices.  This option only makes
+	sense for CDROMs because they can't be partitioned under Linux.
+	For disk devices the generic partition parsing code does this
+	for us.  Defaults to not parsing the partition table at all.
+
+  decompose
+	Decompose file name characters.
+
+  nodecompose
+	Do not decompose file name characters.
+
+  force
+	Used to force write access to volumes that are marked as journalled
+	or locked.  Use at your own risk.
+
+  nls=cccc
+	Encoding to use when presenting file names.
+
+
+References
+==========
+
+kernel source:		<file:fs/hfsplus>
+
+Apple Technote 1150	http://developer.apple.com/technotes/tn/tn1150.html
