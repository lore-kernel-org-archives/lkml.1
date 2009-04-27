Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZD0XaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZD0XaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZD0X35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:29:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbZD0X34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:29:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: utrace: Miscellaneous fixes
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, hch@lst.de, roland@redhat.com,
       linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 00:28:33 +0100
Message-ID: <20090427232833.491.25088.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090427161556.16200.41214.stgit@warthog.procyon.org.uk>
References: <20090427161556.16200.41214.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for the FRV utrace/tracehook code:

 (1) Macro task_pt_regs()'s argument should be bracketed when used.

 (2) The dest data pointer for user_regset_copyin() should point to the place
     at which the data at position start_pos begins.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/ptrace.h |    2 +-
 arch/frv/kernel/ptrace.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/frv/include/asm/ptrace.h b/arch/frv/include/asm/ptrace.h
index 5f8b5e4..a54b535 100644
--- a/arch/frv/include/asm/ptrace.h
+++ b/arch/frv/include/asm/ptrace.h
@@ -81,7 +81,7 @@ extern unsigned long user_stack(const struct pt_regs *);
 extern void show_regs(struct pt_regs *);
 #define profile_pc(regs) ((regs)->pc)
 
-#define task_pt_regs(task) (task->thread.frame0)
+#define task_pt_regs(task) ((task)->thread.frame0)
 
 #define arch_has_single_step()	(1)
 extern void user_enable_single_step(struct task_struct *);
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index e847945..60eeed3 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -92,7 +92,7 @@ static int genregs_set(struct task_struct *target,
 
 	/* set the general regs */
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 iregs, offs_gr1, sizeof(*iregs));
+				 &iregs->gr[1], offs_gr1, sizeof(*iregs));
 	if (ret < 0)
 		return ret;
 

