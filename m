Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYD3Idn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYD3Idn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYD3IdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:33:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756725AbYD3IdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:33:22 -0400
Date: Wed, 30 Apr 2008 01:33:21 -0700 (PDT)
Message-Id: <20080430.013321.112583347.davem@davemloft.net>
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


The main bit here is kgdb support for sparc, but there are also some
cleanups (mostly to facilitate the kgdb changes) and a dup include fix
from Huang Weiyi.

Please pull, thanks a lot!

The following changes since commit 194f1a68b93e959ede6ec363db4714e630bdbb6a:
  Robert Reif (1):
        sparc: video drivers: add facility level

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (5):
      sparc64: Split entry.S up into seperate files.
      sparc64: Kill PIL_RESERVED, unused.
      sparc32: Kill smp_message_pass() and related code.
      kgdbts: Sparc needs sstep emulation.
      sparc: Add kgdb support.

Huang Weiyi (1):
      sparc64: remove duplicated include

 arch/sparc/Kconfig              |    1 +
 arch/sparc/defconfig            |  139 ++-
 arch/sparc/kernel/Makefile      |    1 +
 arch/sparc/kernel/entry.S       |  125 +--
 arch/sparc/kernel/head.S        |    9 +-
 arch/sparc/kernel/kgdb.c        |  164 +++
 arch/sparc/kernel/sparc-stub.c  |  724 -----------
 arch/sparc/kernel/sun4d_smp.c   |   32 -
 arch/sparc/kernel/sun4m_smp.c   |   45 -
 arch/sparc64/Kconfig            |    1 +
 arch/sparc64/kernel/Makefile    |    1 +
 arch/sparc64/kernel/cherrs.S    |  579 +++++++++
 arch/sparc64/kernel/entry.S     | 2575 ---------------------------------------
 arch/sparc64/kernel/fpu_traps.S |  384 ++++++
 arch/sparc64/kernel/getsetcc.S  |   24 +
 arch/sparc64/kernel/head.S      |   15 +-
 arch/sparc64/kernel/helpers.S   |   63 +
 arch/sparc64/kernel/hvcalls.S   |  886 ++++++++++++++
 arch/sparc64/kernel/ivec.S      |   51 +
 arch/sparc64/kernel/kgdb.c      |  186 +++
 arch/sparc64/kernel/misctrap.S  |   97 ++
 arch/sparc64/kernel/smp.c       |   11 +-
 arch/sparc64/kernel/spiterrs.S  |  245 ++++
 arch/sparc64/kernel/syscalls.S  |  279 +++++
 arch/sparc64/kernel/ttable.S    |    2 +-
 arch/sparc64/kernel/utrap.S     |   29 +
 arch/sparc64/mm/ultra.S         |   27 +
 drivers/misc/kgdbts.c           |    2 +-
 include/asm-sparc/head.h        |   11 +
 include/asm-sparc/kgdb.h        |  116 +--
 include/asm-sparc/smp.h         |    2 -
 include/asm-sparc/system.h      |    2 +
 include/asm-sparc64/kgdb.h      |    1 +
 include/asm-sparc64/pil.h       |    7 -
 include/asm-sparc64/system.h    |    5 +-
 include/asm-sparc64/ttable.h    |    6 +
 36 files changed, 3223 insertions(+), 3624 deletions(-)
 create mode 100644 arch/sparc/kernel/kgdb.c
 delete mode 100644 arch/sparc/kernel/sparc-stub.c
 create mode 100644 arch/sparc64/kernel/cherrs.S
 delete mode 100644 arch/sparc64/kernel/entry.S
 create mode 100644 arch/sparc64/kernel/fpu_traps.S
 create mode 100644 arch/sparc64/kernel/getsetcc.S
 create mode 100644 arch/sparc64/kernel/helpers.S
 create mode 100644 arch/sparc64/kernel/hvcalls.S
 create mode 100644 arch/sparc64/kernel/ivec.S
 create mode 100644 arch/sparc64/kernel/kgdb.c
 create mode 100644 arch/sparc64/kernel/misctrap.S
 create mode 100644 arch/sparc64/kernel/spiterrs.S
 create mode 100644 arch/sparc64/kernel/syscalls.S
 create mode 100644 arch/sparc64/kernel/utrap.S
 create mode 100644 include/asm-sparc64/kgdb.h
