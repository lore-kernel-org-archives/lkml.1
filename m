Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZDNHt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZDNHt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDNHtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:49:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:37775 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZDNHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:49:18 -0400
Subject: [PATCH -tip] x86: avoid multiple declaration of
 kstack_depth_to_print
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 13:18:28 +0530
Message-Id: <1239695308.3033.34.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

asm/stacktrace.h is more appropriate so removing other 2 declarations.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/traps.h |    1 -
 arch/x86/kernel/dumpstack.h  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 37fb07a..cbfdc26 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -75,7 +75,6 @@ static inline int get_si_code(unsigned long condition)
 }
 
 extern int panic_on_unrecovered_nmi;
-extern int kstack_depth_to_print;
 
 void math_error(void __user *);
 void math_emulate(struct math_emu_info *);
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index da87590..81086c2 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,7 +29,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *sp, unsigned long bp, char *log_lvl);
 
 extern unsigned int code_bytes;
-extern int kstack_depth_to_print;
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
-- 
1.6.0.6



