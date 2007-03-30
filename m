Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXC3XKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXC3XKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXC3XJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:09:35 -0400
Received: from mbox.ssc.unict.it ([151.97.230.9]:52873 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933020AbXC3XIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:08:55 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 1/3] utrace - uml: make UML compile with utrace enabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       Roland McGrath <roland@redhat.com>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Date: Sat, 31 Mar 2007 01:08:04 +0200
Message-ID: <20070330230804.19809.55294.stgit@americanbeauty.home.lan>
In-Reply-To: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* The prototype of arch_ptrace doesn't match the one in include/linux/ptrace.h.
* utrace_um_native is referred to by utrace_native_view but never defined.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/kernel/ptrace.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index f66d01c..a42caf3 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -16,7 +16,12 @@ void ptrace_disable(struct task_struct *child)
 { 
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+const struct utrace_regset_view utrace_um_native;
+
+int arch_ptrace(long *request, struct task_struct *child,
+		       struct utrace_attached_engine *engine,
+		       unsigned long addr, unsigned long data,
+		       long *retval)
 {
 	return -ENOSYS;
 }



