Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYLBWvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYLBWvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYLBWvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:51:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:57338 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYLBWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gmzWk6NBK4Rarld4goviYM2ktoNd08PTR3cbtGdszYMN2JR2qMdNBKTTiJNiAdtNNm
         zqh79s+GryNVCEK8j9LWY8C7ukwb/4WB+ZkcFTAuJ2BNDqN0KbHzRqrjCzqlJbAAaEHS
         IWmGWxM374NWAw1TcnBM4lnyg+/6PRXFoZEF8=
Message-ID: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
Date: Tue, 2 Dec 2008 22:51:09 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [Patch] uml: drop const qualifier for kernel_execve()
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML implementation of kernel_execve() should not have const qualifier,
because it will finally call do_execve() which doesn't have.

This also shuts up a gcc warning on this.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index c4df705..4fa62ee 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -120,7 +120,7 @@ long sys_olduname(struct oldold_utsname __user * name)
 	return error;
 }

-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(char *filename, char * argv[], char * envp[])
 {
 	mm_segment_t fs;
 	int ret;
