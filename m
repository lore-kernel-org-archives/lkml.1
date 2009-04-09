Return-Path: <linux-kernel-owner+w=401wt.eu-S936514AbZDIQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936514AbZDIQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936135AbZDIQiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:38:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:32920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936124AbZDIQiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:38:20 -0400
Subject: [PATCH -tip] x86: ftrace.c declare prepare_ftrace_return before
 they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 22:07:48 +0530
Message-Id: <1239295068.3296.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning:
  arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/ftrace.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index bd2c651..49616d4 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -62,4 +62,10 @@ struct dyn_arch_ftrace {
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#ifndef __ASSEMBLY__
+extern void prepare_ftrace_return(unsigned long *, unsigned long);
+#endif
+#endif
+
 #endif /* _ASM_X86_FTRACE_H */
-- 
1.6.0.6



