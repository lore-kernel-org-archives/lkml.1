Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYISC2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYISC2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 22:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYISC2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 22:28:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49649
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbYISC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 22:28:39 -0400
Date: Thu, 18 Sep 2008 19:28:27 -0700 (PDT)
Message-Id: <20080918.192827.202370570.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two bug fixes:

1) psycho_pcierr_intr_other() dereferences a NULL pointer.  Root
   PCI controller config space accesses need to be done by hand.
   Reported and tested by Meelis Roos on Sun Enterprise 3500.

2) We have several methods of booting up cpus, depending upon what
   features the firmware and/or hypervisor support.  On some of
   those paths we have to call C code before the current_thread_info()
   register can be setup properly.

   By calling C code invokes _mcount when the kernel is built with
   "-pg" (due to CONFIG_STACK_DEBUG or ftrace being enabled), and
   _mcount does stack depth checking using the current thread register
   because that defines the base of the current non-interrupt kernel
   stack.

   Fix this by marking these super-early-init routines as "notrace".

   Also reported and tested by Meelis Roos.

Please pull, thanks a lot!

The following changes since commit 6bfb09a1005193be5c81ebac9f3ef85210142650:
  Linus Torvalds (1):
        Merge master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Fix OOPS in psycho_pcierr_intr_other().
      sparc64: Fix SMP bootup with CONFIG_STACK_DEBUG or ftrace.

 arch/sparc64/kernel/irq.c        |    5 +++--
 arch/sparc64/kernel/pci_psycho.c |    8 +++++---
 arch/sparc64/kernel/traps.c      |    3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)
