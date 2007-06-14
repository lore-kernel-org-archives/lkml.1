Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbXFNFix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbXFNFix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXFNFip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:38:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbXFNFio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:38:44 -0400
Date: Thu, 14 Jun 2007 07:38:33 +0200
From: Nick Piggin <npiggin@suse.de>
To: jdike@addtoit.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] uml: better bugs
Message-ID: <20070614053833.GC2975@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get UML to use the generic bug support rather than arch specific one.

If I insert an artificial bug right before loading init, I get this:

 Kernel panic - not syncing: Kernel mode signal 4

 EIP: 0023:[<0819d501>] CPU: 0 Not tainted ESP: 002b:f7fd4fbc EFLAGS: 00000246
    Not tainted
    EAX: 00000000 EBX: 00007870 ECX: 00000013 EDX: 00007870
    ESI: 0000786d EDI: 00000011 EBP: f7fd4fd8 DS: 002b ES: 002b
    08273bec:  [<0806e814>] show_regs+0x104/0x106
    08273c08:  [<08058927>] panic_exit+0x2c/0x4b
    08273c18:  [<08080ee7>] notifier_call_chain+0x32/0x5b
    08273c38:  [<08080fbd>] __atomic_notifier_call_chain+0x30/0x32
    08273c54:  [<08080fee>] atomic_notifier_call_chain+0x2f/0x31
    08273c70:  [<08073b88>] panic+0x75/0x131
    08273c94:  [<080586c7>] relay_signal+0x87/0x95
    08273cb0:  [<0806b9ee>] sig_handler_common_skas+0x9e/0x120
    08273cd8:  [<08067738>] sig_handler+0x28/0x4f
    08273cec:  [<0806792e>] handle_signal+0x53/0x89
    08273d0c:  [<08069f60>] hard_handler+0x18/0x28
    08273d1c:  [<ffffe500>] transitions+0xf7d598b8/0xfffffff0


With this patch in place, this is how it looks:
    
 BUG: failure at init/main.c:779/init_post()!
 Kernel panic - not syncing: BUG!

 EIP: 0023:[<081a65d1>] CPU: 0 Not tainted ESP: 002b:f7f0dfbc EFLAGS: 00000246
    Not tainted
    EAX: 00000000 EBX: 000069db ECX: 00000013 EDX: 000069db
    ESI: 000069d8 EDI: 00000011 EBP: f7f0dfd8 DS: 002b ES: 002b
    098efedc:  [<0806e9a4>] show_regs+0x104/0x106
    098efef8:  [<080589c7>] panic_exit+0x2c/0x4b
    098eff08:  [<080818d7>] notifier_call_chain+0x32/0x5b
    098eff28:  [<080819ad>] __atomic_notifier_call_chain+0x30/0x32
    098eff44:  [<080819de>] atomic_notifier_call_chain+0x2f/0x31
    098eff60:  [<08073f28>] panic+0x75/0x131
    098eff84:  [<080541d5>] init_post+0xcd/0xe8
    098eff9c:  [<08048ad4>] kernel_init+0x8e/0x9a
    098effb4:  [<08066dee>] run_kernel_thread+0x41/0x53
    098effe0:  [<08058e75>] new_thread_handler+0x62/0x8b
    098efffc:  [<a55a5a5a>] 0xa55a5a5a


Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/include/asm-um/bug.h
===================================================================
--- linux-2.6.orig/include/asm-um/bug.h	2007-06-04 22:24:19.000000000 +1000
+++ linux-2.6/include/asm-um/bug.h	2007-06-04 22:24:24.000000000 +1000
@@ -1,6 +1,6 @@
 #ifndef __UM_BUG_H
 #define __UM_BUG_H
 
-#include <asm/arch/bug.h>
+#include <asm-generic/bug.h>
 
 #endif
