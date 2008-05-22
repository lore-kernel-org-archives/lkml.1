Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYEVEzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYEVEzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYEVEzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:55:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45274
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYEVEzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:55:07 -0400
Date: Wed, 21 May 2008 21:55:00 -0700 (PDT)
Message-Id: <20080521.215500.193704988.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several fixes here:

1) If hypervisor console runs on older firmware and has to
   use byte-at-a-time console I/O, it will deadlock immediately
   on SMP.

2) The way kernel stacks are setup for kernel threads creates a frame
   pointer loop at the top of the stack, fix and NULL terminate the
   stack linkage or else backtraces that follow through trap frames
   end up being bogus.

3) Offsets of the pt_regs objects were wrong in stack backtrace code.

4) When returning from a kernel originating trap, we need to clear
   out the pt_regs magic value to prevent false positive hits in
   future backtraces.

Please pull, thanks a lot!

The following changes since commit 93dae5b70e7c1c8e927d22e1c20a941ca376906a:
  David S. Miller (1):
        sparc64: Add global register dumping facility.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sunhv: Fix locking in non-paged I/O case.
      sparc64: Fix kernel thread stack termination.
      sparc64: Fix stack tracing through trap frames.
      sparc64: Prevent stack backtrace false positives on trap frames.

 arch/sparc64/kernel/process.c    |   36 +++++++++++++++++++++++++-----------
 arch/sparc64/kernel/rtrap.S      |    1 +
 arch/sparc64/kernel/stacktrace.c |   12 +++++++-----
 arch/sparc64/kernel/traps.c      |   12 +++++++-----
 drivers/serial/sunhv.c           |    1 -
 5 files changed, 40 insertions(+), 22 deletions(-)
