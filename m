Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbYHMXpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbYHMXpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYHMXpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:45:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41794
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbYHMXpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:45:18 -0400
Date: Wed, 13 Aug 2008 16:45:20 -0700 (PDT)
Message-Id: <20080813.164520.86944543.davem@davemloft.net>
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


Bug fixes:

1) Fix build when MAGIC_SYSRQ is turned off.

2) of_device.h header usage cleanups from Stephen Rothwell.

3) Implement IRQ stacks to deal with very real deep stack code path
   situations, as reported by Mikulas Patocka.  Also, fix a recursion
   bug in stack overflow detection.

Please pull, thanks a lot!

The following changes since commit 433c5f706856689be25928a99636e724fb3ea7cf:
  David S. Miller (1):
        sparc64: Fix end-of-stack checking in save_stack_trace().

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc64: Don't MAGIC_SYSRQ ifdef smp_fetch_global_regs and support code.
      sparc64: Fix recursion in stack overflow detection handling.
      sparc64: Implement IRQ stacks.

Stephen Rothwell (2):
      sparc/drivers: use linux/of_device.h instead of asm/of_device.h
      sparc: remove include of linux/of_device.h from asm/of_device.h

 arch/sparc/include/asm/irq_64.h     |    4 ++
 arch/sparc/include/asm/of_device.h  |    3 +-
 arch/sparc64/kernel/irq.c           |   52 +++++++++++++++++++++++++++++++
 arch/sparc64/kernel/kstack.h        |   58 +++++++++++++++++++++++++++++++++++
 arch/sparc64/kernel/process.c       |   27 ++++------------
 arch/sparc64/kernel/smp.c           |    4 --
 arch/sparc64/kernel/stacktrace.c    |   10 ++---
 arch/sparc64/kernel/traps.c         |    7 ++--
 arch/sparc64/lib/mcount.S           |   39 +++++++++++++++++++++--
 arch/sparc64/mm/init.c              |   11 ++++++
 arch/sparc64/mm/ultra.S             |    2 -
 drivers/input/serio/i8042-sparcio.h |    3 +-
 drivers/sbus/sbus.c                 |    2 +-
 drivers/serial/sunhv.c              |    2 +-
 drivers/serial/sunsab.c             |    2 +-
 drivers/serial/sunsu.c              |    2 +-
 drivers/serial/sunzilog.c           |    2 +-
 17 files changed, 183 insertions(+), 47 deletions(-)
 create mode 100644 arch/sparc64/kernel/kstack.h
