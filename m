Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZH0RW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZH0RW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZH0RW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZH0RWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:22:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 5/6] kprobes/x86-64: Fix to move
	common_interrupt to .kprobes.text
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 27 Aug 2009 13:23:25 -0400
Message-ID: <20090827172325.8246.40000.stgit@localhost.localdomain>
In-Reply-To: <20090827152539.GE6058@nowhere>
References: <20090827152539.GE6058@nowhere>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nmi, debug and int3 returns to irq_return in the common_interrupt,
probing this function will cause int3-loop, so it should be marked
as __kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/entry_64.S |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c251be7..36e2ef5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -809,6 +809,10 @@ END(interrupt)
 	call \func
 	.endm
 
+/*
+ * Interrupt entry/exit should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
 	/*
 	 * The interrupt stubs push (~vector+0x80) onto the stack and
 	 * then jump to common_interrupt.
@@ -947,6 +951,10 @@ ENTRY(retint_kernel)
 
 	CFI_ENDPROC
 END(common_interrupt)
+/*
+ * End of kprobes section
+ */
+       .popsection
 
 /*
  * APIC interrupts.


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
