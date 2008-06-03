Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYFCTEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYFCTEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbYFCTEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:04:07 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58521 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYFCTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:04:05 -0400
Date: Tue, 3 Jun 2008 15:02:37 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Subject: [PATCH 5/6] UML - stub needs to tolerate SIGWINCH
Message-ID: <20080603190237.GA9515@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We lost the marking of SIGWINCH as being OK to receive during stub
execution, causing a panic should that happen.

Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/skas/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2008-04-14 10:44:33.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2008-05-13 11:37:35.000000000 -0400
@@ -55,7 +55,7 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK (1 << SIGVTALRM)
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
 
 /* Signals that the stub will finish with - anything else is an error */
 #define STUB_DONE_MASK (1 << SIGTRAP)
