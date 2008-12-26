Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYLZJk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLZJk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYLZJkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:40:17 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:18013 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYLZJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DUiN1GUDBPOjlOYHFbXws1G6y+4niKIjksTE4cMllOHMIcazRI6o4+ppvShOuufuvb
         ZKIG9B+ckETrsFf4MEVRco/S7aCD3smY405fsROIx4NaK7hHZGH/QiNOH32qfufEtUJD
         5P0QI+z1Ar/nh/D0uEEC8ifFxPkKF5aEkQWLU=
Date: Fri, 26 Dec 2008 17:38:55 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] fs/exec.c: make do_coredump() void
Message-ID: <20081226173855.GF3156@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No one cares do_coredump()'s return value, and also it seems that it
is also not necessary. So make it void.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>


---
diff --git a/fs/exec.c b/fs/exec.c
index ec5df9a..c48a040 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1708,7 +1708,7 @@ int get_dumpable(struct mm_struct *mm)
 	return (ret >= 2) ? 2 : ret;
 }
 
-int do_coredump(long signr, int exit_code, struct pt_regs * regs)
+void do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
 	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
@@ -1845,5 +1845,5 @@ fail_unlock:
 	current->fsuid = fsuid;
 	coredump_finish(mm);
 fail:
-	return retval;
+	return;
 }
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 7394b5b..a063f7e 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -102,7 +102,7 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 extern int bprm_mm_init(struct linux_binprm *bprm);
 extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
 extern void compute_creds(struct linux_binprm *binprm);
-extern int do_coredump(long signr, int exit_code, struct pt_regs * regs);
+extern void do_coredump(long signr, int exit_code, struct pt_regs * regs);
 extern int set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 

