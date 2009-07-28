Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZG1Xo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZG1Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZG1Xo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:44:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57449 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbZG1Xo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:44:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH] kprobes: Use kernel_text_address() for checking probe
	address
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Tue, 28 Jul 2009 19:47:23 -0400
Message-ID: <20090728234723.15708.54455.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel_text_address() for checking probe address instead of
__kernel_text_address(), because __kernel_text_address() returns
!0 for init functions even after relaseing those functions.
That will hit a BUG() in text_poke().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 16b5739..0540948 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -694,7 +694,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 	p->addr = addr;
 
 	preempt_disable();
-	if (!__kernel_text_address((unsigned long) p->addr) ||
+	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr)) {
 		preempt_enable();
 		return -EINVAL;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
