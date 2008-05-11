Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYEKJ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYEKJ2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYEKJ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:28:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48498
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbYEKJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:28:25 -0400
Date: Sun, 11 May 2008 02:28:19 -0700 (PDT)
Message-Id: <20080511.022819.13047794.davem@davemloft.net>
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


Bug fixes for sparc:

1) sparc32 referencing PT_DTRACE which it has no reason to

2) ptrace() detach broken, because the wrong value is being
   used by userspace headers, fix by translating if we see
   the value userland actually uses.   That value doesn't
   conflict with other ptrace() request numbers we care about
   so this is OK.

3) Provide a state akin to ->orig_eax on x86 that allows the debugger
   to control syscall restart properly.

   This, along with the matching gdb patch, kills about 40 or so gdb
   testsuite failures on 32-bit and 64-bit sparc.

   As a result M68K is now the only user of ptrace_signal_deliver(),
   it's broken the same exact way sparc was, and thus needs similar
   fixes.

4) Tidy Sparc video driver open-firmware interface usage, from Robert
   Reif.

Please pull, thanks a lot!

The following changes since commit dc5dc7e6d71ca9fd1ea01a1418150af3b2937489:
  David S. Miller (1):
        sparc: Fix SA_ONSTACK signal handling.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (3):
      sparc32: Don't twiddle PT_DTRACE in exec.
      sparc: Fix ptrace() detach.
      sparc: Fix debugger syscall restart interactions.

Robert Reif (1):
      sparc video: remove open boot prom code

 arch/sparc/kernel/entry.S       |    2 +
 arch/sparc/kernel/process.c     |    5 ---
 arch/sparc/kernel/ptrace.c      |    6 ++-
 arch/sparc/kernel/rtrap.S       |   11 +++++--
 arch/sparc/kernel/signal.c      |   64 +++++++++++++++++----------------------
 arch/sparc64/kernel/etrap.S     |    7 ++--
 arch/sparc64/kernel/ptrace.c    |   16 +++++++---
 arch/sparc64/kernel/rtrap.S     |    1 +
 arch/sparc64/kernel/signal.c    |   60 +++++++++++++-----------------------
 arch/sparc64/kernel/signal32.c  |   26 ++++++++++-----
 drivers/video/bw2.c             |    6 +--
 drivers/video/cg14.c            |    5 +--
 drivers/video/cg3.c             |    6 +--
 drivers/video/cg6.c             |    4 +-
 drivers/video/ffb.c             |    5 +--
 drivers/video/leo.c             |    5 +--
 drivers/video/p9100.c           |    5 +--
 drivers/video/sbuslib.c         |    9 +++--
 drivers/video/sbuslib.h         |    5 ++-
 drivers/video/sunxvr2500.c      |    3 +-
 drivers/video/sunxvr500.c       |    3 +-
 drivers/video/tcx.c             |    5 +--
 include/asm-sparc/psr.h         |    1 +
 include/asm-sparc/ptrace.h      |   11 +++++++
 include/asm-sparc/signal.h      |    8 +----
 include/asm-sparc64/psrcompat.h |    2 +
 include/asm-sparc64/pstate.h    |    1 +
 include/asm-sparc64/ptrace.h    |   11 +++----
 include/asm-sparc64/signal.h    |    8 +----
 include/asm-sparc64/ttable.h    |    7 ++--
 30 files changed, 149 insertions(+), 159 deletions(-)
