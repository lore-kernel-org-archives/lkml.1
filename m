Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZBJOwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZBJOwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZBJOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:51:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:5721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZBJOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:51:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IWJsHdgKoFW1baCZXd3aqsfyQ9Zks4YrkpRY+SAc9bszoxPfh8jaWgj4yyFt7CPTYv
         pRh6Jzbun23oAnvzbd19PpF4k3xeFl04TB/tdahdEsxSqqzkGp7IQYJBbOIVdY//7GwJ
         3GIyiw02CBWxedTkck8GPfpPhNKaraI9fV/9Q=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: Drop -fno-stack-protector after pt_regs fixes
Date: Tue, 10 Feb 2009 09:51:47 -0500
Message-Id: <1234277507-4987-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that no functions rely on struct pt_regs being passed by value,
stack protector can be enabled.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/Makefile |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b1f8be3..37fa30b 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -24,24 +24,6 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
-#
-# On x86_32, register frame is passed verbatim on stack as struct
-# pt_regs.  gcc considers the parameter to belong to the callee and
-# with -fstack-protector it copies pt_regs to the callee's stack frame
-# to put the structure after the stack canary causing changes made by
-# the exception handlers to be lost.  Turn off stack protector for all
-# files containing functions which take struct pt_regs from register
-# frame.
-#
-# The proper way to fix this is to teach gcc that the argument belongs
-# to the caller for these functions, oh well...
-#
-ifdef CONFIG_X86_32
-CFLAGS_process_32.o	:= $(nostackp)
-CFLAGS_vm86_32.o	:= $(nostackp)
-CFLAGS_signal.o		:= $(nostackp)
-CFLAGS_traps.o		:= $(nostackp)
-endif
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
-- 
1.6.1

