Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0CDI2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:28:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54093
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab0CDI16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:27:58 -0500
Date: Thu, 04 Mar 2010 00:28:17 -0800 (PST)
Message-Id: <20100304.002817.98885540.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Fix long standing bootup wedge wrt. NMIs, we need to disable NMIs
   when we enter the firmware for two reasons.  One so we don't
   deadlock on the PROM spinlock if we try to print things to the
   firmware console from an NMI.  Two, because many of OpenFirmware's
   routines do not like to be interrupted at all.  The latter can
   cause garbage characters over serial consoles and crashes.

   I'll be pushing this one to -stable.

2) Kill off the dinky sys_perfctr, perf_events should be used.

3) Fix some driver builds by providing big-endian io{read,write}*().

Please pull, thanks a lot!

The following changes since commit 3a5b27bf6f29574d667230c7e76e4b83fe3014e0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc: Provide io{read,write}{16,32}be().
      sparc: Update defconfigs.
      sparc64: Kill off old sys_perfctr system call and state.
      sparc64: Make prom entry spinlock NMI safe.

 arch/sparc/configs/sparc32_defconfig    |   56 ++++++++++++++---
 arch/sparc/configs/sparc64_defconfig    |   34 ++++++----
 arch/sparc/include/asm/io_32.h          |    4 +
 arch/sparc/include/asm/io_64.h          |    4 +
 arch/sparc/include/asm/perfctr.h        |    4 +-
 arch/sparc/include/asm/system_64.h      |   15 +----
 arch/sparc/include/asm/thread_info_64.h |   25 ++-----
 arch/sparc/kernel/entry.h               |    1 -
 arch/sparc/kernel/process_64.c          |   23 -------
 arch/sparc/kernel/rtrap_64.S            |   54 +---------------
 arch/sparc/kernel/sys32.S               |    1 -
 arch/sparc/kernel/sys_sparc_64.c        |  104 -------------------------------
 arch/sparc/kernel/syscalls.S            |   23 +------
 arch/sparc/kernel/systbls.h             |    2 -
 arch/sparc/kernel/systbls_64.S          |    4 +-
 arch/sparc/kernel/traps_64.c            |    9 ---
 arch/sparc/prom/p1275.c                 |   12 ++--
 17 files changed, 99 insertions(+), 276 deletions(-)
