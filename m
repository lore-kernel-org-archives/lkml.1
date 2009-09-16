Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZIPS5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZIPS5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbZIPS5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:57:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbZIPS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:57:11 -0400
Message-Id: <20090916185713.843657189@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 14:55:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] [PATCH 1/2] tracing: remove notrace from __kprobes annotation
References: <20090916185546.986682049@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-remove-notrace-from-__kprobes-annotation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When ftrace had issues with NMIs, it was needed to annotate all
the areas that kprobes had issues with notrace. Now that ftrace is
NMI safe, the functions that limit ftrace from tracing are just a
small few.

Kprobes is too big of a set for ftrace not to trace. Remove the
coupling.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kprobes.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index bcd9c07..3a46b7b 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -48,13 +48,13 @@
 #define KPROBE_HIT_SSDONE	0x00000008
 
 /* Attach to insert probes on any functions which should be ignored*/
-#define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
+#define __kprobes	__attribute__((__section__(".kprobes.text")))
 #else /* CONFIG_KPROBES */
 typedef int kprobe_opcode_t;
 struct arch_specific_insn {
 	int dummy;
 };
-#define __kprobes	notrace
+#define __kprobes
 #endif /* CONFIG_KPROBES */
 
 struct kprobe;
-- 
1.6.3.3


