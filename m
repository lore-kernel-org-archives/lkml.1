Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbXEPJl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbXEPJl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXEPJlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:41:52 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:24523 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbXEPJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:41:51 -0400
Message-ID: <464AD1DB.3050609@linux-kernel.at>
Date: Wed, 16 May 2007 11:41:47 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070419 Fedora/2.0.0.0-1.fc7 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] Missing defines in asm-alpha/unistd.h!?
References: <464AC75D.1090701@linux-kernel.at>
In-Reply-To: <464AC75D.1090701@linux-kernel.at>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050604000409010305040409"
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050604000409010305040409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/16/2007 10:57 AM, Oliver Falk wrote:
> I believe this is missing... :-) I hope I understood NR_SYSCALLS
> correctly and it's the number of defined syscals - as I added 20 of
> them, I increased it by 20... Maybe someone can have a look if it's correct.
[ ... ]

Sorry, the patch was missing one hunk/file and also the tab stops where
wrong. Attached a new working version.

- -of
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGStDwxWN5Ge8lKUMRAp9pAJ9VWmpI5zSUmW4s99I/8YC0Cw60lgCgvIHR
iRRdK8OTSVMepjQbNRWfQYA=
=HexW
-----END PGP SIGNATURE-----

--------------050604000409010305040409
Content-Type: text/x-patch;
 name="linux-2.6.21-alpha_missing_syscalls.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.21-alpha_missing_syscalls.patch"

--- linux-2.6.21/include/asm-alpha/unistd.h.missing_defines	2007-05-16 10:53:02.000000000 +0200
+++ linux-2.6.21/include/asm-alpha/unistd.h	2007-05-16 10:54:44.000000000 +0200
@@ -388,9 +388,30 @@
 #define __NR_inotify_add_watch		445
 #define __NR_inotify_rm_watch		446
 
+#define __NR_openat             447
+#define __NR_mkdirat            448
+#define __NR_mknodat            449
+#define __NR_fchownat           450
+#define __NR_futimesat          451
+#define __NR_unlinkat           452
+#define __NR_renameat           453
+#define __NR_linkat             454
+#define __NR_symlinkat          455
+#define __NR_readlinkat         456
+#define __NR_fchmodat           457
+#define __NR_faccessat          458
+#define __NR_pselect6           459
+#define __NR_ppoll              460
+#define __NR_unshare            461
+#define __NR_set_robust_list    462
+#define __NR_get_robust_list    463
+#define __NR_splice             464
+#define __NR_sync_file_range    465
+#define __NR_tee                466
+
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			447
+#define NR_SYSCALLS			467
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
--- linux-2.6.21/arch/alpha/kernel/systbls.S.missing_defines	2007-05-16 11:32:29.000000000 +0200
+++ linux-2.6.21/arch/alpha/kernel/systbls.S	2007-05-16 11:30:36.000000000 +0200
@@ -465,6 +465,26 @@
 	.quad sys_inotify_init
 	.quad sys_inotify_add_watch		/* 445 */
 	.quad sys_inotify_rm_watch
+	.quad sys_openat
+	.quad sys_mkdirat
+	.quad sys_mknodat
+	.quad sys_fchownat          /* 450 */
+	.quad sys_futimesat
+	.quad sys_unlinkat
+	.quad sys_renameat
+	.quad sys_linkat
+	.quad sys_symlinkat         /* 455 */
+	.quad sys_readlinkat
+	.quad sys_fchmodat
+	.quad sys_faccessat
+	.quad sys_pselect6
+	.quad sys_ppoll             /* 460 */
+	.quad sys_unshare
+	.quad sys_set_robust_list
+	.quad sys_get_robust_list
+	.quad sys_splice
+	.quad sys_sync_file_range
+	.quad sys_tee
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object

--------------050604000409010305040409--
