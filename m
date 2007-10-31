Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXJaADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXJaADx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbXJaADm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:03:42 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64901 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXJaADl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:03:41 -0400
Subject: [PATCH] dump_stack on panic
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Daniel Walker <dwalker@mvista.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 20:02:59 -0400
Message-Id: <1193788979.5623.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why we don't do a dump_stack on panic?

I find this soooo useful in the -rt patch, where Ingo has placed a
dump_stack on panic. With mainline, when I hit a panic, I don't always
know how it got there. So I find myself adding the dump_stack and trying
to create the bug again.

This patch simply adds dump_stack to panic.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/panic.c b/kernel/panic.c
index 6f6e03e..bd481d7 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -78,6 +78,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	dump_stack();
 	bust_spinlocks(0);
 
 	/*


