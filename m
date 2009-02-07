Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZBGUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZBGUXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZBGUXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:23:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:38510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZBGUXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:23:24 -0500
Date: Sat, 7 Feb 2009 12:23:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] x86: Don't pretend that non-framepointer stack traces are
 reliable
Message-ID: <20090207122337.4c0f25b7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f460ce92e09770691855b98a904556e92d39ead9 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 7 Feb 2009 12:20:20 -0800
Subject: [PATCH] x86: Don't pretend that non-framepointer stack traces are reliable

without frame pointers enabled, the x86 stack traces should not
pretend to be reliable; instead they should just be what they are:
unreliable.

The effect of this is that they have a ? printed in the stacktrace,
to warn the reader that these entries are guesses rather than known
based on more reliable information.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/dumpstack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 077c9ea..4eda941 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -100,7 +100,7 @@ print_context_stack(struct thread_info *tinfo,
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
 			} else {
-				ops->address(data, addr, bp == 0);
+				ops->address(data, addr, 0);
 			}
 			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 		}
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
