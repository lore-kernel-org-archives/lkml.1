Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbXHGUQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbXHGUQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXHGUPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:15:52 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39348 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXHGUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:15:51 -0400
Date: Tue, 7 Aug 2007 22:16:03 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove binfmts.h from header exports
Message-ID: <20070807201603.GB31501@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


remove linux/binfmts.h from make headers_install

A recent patch added PAGE_SIZE to the part outside of __KERNEL__.
qemu and ia32el have their own define of MAX_ARG_PAGES.
No package uses linux/binfmts.h, so it is safe to not provide it.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/Kbuild    |    1 -
 include/linux/binfmts.h |    2 --
 2 files changed, 3 deletions(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -173,7 +173,6 @@ unifdef-y += atm.h
 unifdef-y += atm_tcp.h
 unifdef-y += audit.h
 unifdef-y += auto_fs.h
-unifdef-y += binfmts.h
 unifdef-y += capability.h
 unifdef-y += capi.h
 unifdef-y += cciss_ioctl.h
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -17,7 +17,6 @@ struct pt_regs;
 /* sizeof(linux_binprm->buf) */
 #define BINPRM_BUF_SIZE 128
 
-#ifdef __KERNEL__
 
 #define CORENAME_MAX_SIZE 128
 
@@ -99,5 +98,4 @@ extern void compute_creds(struct linux_b
 extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_BINFMTS_H */
