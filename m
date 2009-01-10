Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbZAJFsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbZAJFsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZAJFsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:48:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:33832 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJFsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=XJag2Ps5y/0XoyjdzNrR3EJNNDRLGruvA06lZTOjGPYPnSErue1TMSAqDt1nAfCLbP
         WwKZspyNCYsbgnptvS3bsrOvRy3xjKxTmX9raIonFL8GjRP3naQCBavb6AAdL53XgcGE
         QVzPCdu+8dJsw9WG5uq76L61aSSsxpKewbQK4=
Subject: [PATCH] Disable branch profiling macros when sparsed.
To: linux-kernel@vger.kernel.org
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 10 Jan 2009 08:57:28 +0300
Message-ID: <20090110052727.5471.3654.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros produce lots of unneeded warnings when
recursive if(({ .. if() {..} ..})) {..} and such
are substituted. And there is no point in sparsing
them anyway. This is useful if someone decides to
sparse an allyesconfig kernel.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---

Also, there is little point in profiling unlikely() inside
WARN_ON() and friends, so maybe they should be replaced
with the _notrace counterparts?

 include/linux/compiler.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d95da10..f5f173b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -17,6 +17,7 @@
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
+# define DISABLE_BRANCH_PROFILING
 #else
 # define __user
 # define __kernel

