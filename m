Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYECDCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYECDCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 23:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYECDCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 23:02:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37969
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756685AbYECDCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 23:02:19 -0400
Date: Fri, 02 May 2008 20:02:19 -0700 (PDT)
Message-Id: <20080502.200219.71669676.davem@davemloft.net>
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


Some sparc32 cleanups triggered by some gcc-4.3 warnings
I saw there.

More fixes to syscall restart handling, I think I have it
right now and I haven't seen any weird behavior for a few
days.

All the sparc serial drivers were using the same driver
name string, resulting in all kinds of problems which
the kernel now duly warns about.

Similarly wrt. sparc64 PCI host controller registry.
Just don't try to make the dummy root host controller
and all the problems go away.

Please pull, thanks a lot!

The following changes since commit 886c35fbcf6fb2eee15687efc2d64d99b6ad9a4a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (6):
      sparc64: Stop creating dummy root PCI host controller devices.
      serial: Fix sparc driver name strings.
      sparc64: Fix syscall restart, for real...
      sparc32: Kill totally unused memory information tables.
      sparc32: More memory probing consolidation.
      sparc32: Delete prom_stdin and prom_stdout.

 arch/sparc/kernel/setup.c        |    5 +-
 arch/sparc/mm/fault.c            |   61 +---------
 arch/sparc/prom/init.c           |    7 -
 arch/sparc/prom/memory.c         |  235 ++++++++++----------------------------
 arch/sparc64/kernel/pci.c        |  130 ++++++----------------
 arch/sparc64/kernel/pci_common.c |    6 -
 arch/sparc64/kernel/pci_impl.h   |    9 --
 arch/sparc64/kernel/process.c    |    6 -
 arch/sparc64/kernel/signal.c     |    6 +-
 arch/sparc64/kernel/signal32.c   |    6 +
 drivers/serial/sunhv.c           |    2 +-
 drivers/serial/sunsab.c          |    2 +-
 drivers/serial/sunsu.c           |    2 +-
 drivers/serial/sunzilog.c        |    2 +-
 include/asm-sparc/oplib.h        |   17 ---
 include/asm-sparc/page.h         |    5 +-
 16 files changed, 117 insertions(+), 384 deletions(-)
