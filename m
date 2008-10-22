Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYJVUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYJVUBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:01:05 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:40692 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYJVUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iP1m604yeaoMfGwueJGE8Z1SrrlLpR6zqVL6AHfOqwUWJNk25xtPISQqam1jr8aHVv
         fbtwz2F2Ly9k0xIYduhg8IljH+AZ1kXLq1LTgsJdtm/6iZJRLAADVAudA7YxAlAGQ4VR
         JgXV+w8pYe/F4hdWKMwjICnEfm3UTLIW32kH4=
Message-ID: <f1c9d250810221301hb514aady73203bf489e0932b@mail.gmail.com>
Date: Thu, 23 Oct 2008 01:31:02 +0530
From: Tej <bewith.tej@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] build error: 2.6.17-rc5
Cc: sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

observed following build error for 2.6.17-rc5 kernel (git repo)

<---snip---->
/opt/Testing/Tools/linux-2.6/init/do_mounts.c:115: undefined reference
to `__stack_chk_fail'
init/built-in.o: In function `name_to_dev_t':
/opt/Testing/Tools/linux-2.6/init/do_mounts.c:206: undefined reference
to `__stack_chk_fail'
init/built-in.o: In function `change_floppy':
/opt/Testing/Tools/linux-2.6/init/do_mounts.c:363: undefined reference
to `__stack_chk_fail'
init/built-in.o: In function `mount_block_root':
/opt/Testing/Tools/linux-2.6/init/do_mounts.c:321: undefined reference
to `__stack_chk_fail'
init/built-in.o: In function `do_header':
/opt/Testing/Tools/linux-2.6/init/initramfs.c:206: undefined reference
to `__stack_chk_fail'
arch/i386/kernel/built-in.o:/opt/Testing/Tools/linux-2.6/arch/i386/kernel/ptrace.c:634:
more undefined references to `__stack_chk_fail' follow
make: *** [.tmp_vmlinux1] Error 1

attached patch solve problem, which seems to be obvious by looking at
defination of "__stack_chk_fail" with subsequent kernel versions.

Signed-off-by: Tej Parkash <bewith.tej@gmail.com>

diff --git a/Makefile b/Makefile
index 435d209..d2afeea 100644
--- a/Makefile
+++ b/Makefile
@@ -306,7 +306,7 @@ LINUXINCLUDE    := -Iinclude \
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)

 CFLAGS                 := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-                  -fno-strict-aliasing -fno-common
+                  -fno-strict-aliasing -fno-common -fno-stack-protector
 AFLAGS         := -D__ASSEMBLY__

 # Read KERNELRELEASE from .kernelrelease (if it exists)
