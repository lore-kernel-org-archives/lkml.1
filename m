Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbYHEUT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbYHEUT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763733AbYHEUOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:45 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48098 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763683AbYHEUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:43 -0400
Date: Tue, 5 Aug 2008 16:14:09 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 10/14] uml: stub needs to tolerate SIGWINCH
Message-ID: <20080805201409.GA11798@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3d5ede6f776bdb1483bcd086f79c3bf41fed3865

We lost the marking of SIGWINCH as being OK to receive during stub
execution, causing a panic should that happen.

Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/os-Linux/skas/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 1e8cba6..2328098 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -55,7 +55,7 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK (1 << SIGVTALRM)
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
 
 /* Signals that the stub will finish with - anything else is an error */
 #define STUB_DONE_MASK (1 << SIGTRAP)
-- 
1.5.5.1

