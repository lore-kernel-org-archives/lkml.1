Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZFLNAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZFLNAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762320AbZFLM7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:04 -0400
Received: from ozlabs.org ([203.10.76.45]:34413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762226AbZFLM7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest -- Now including PAE support!
Date: Fri, 12 Jun 2009 22:28:59 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       Ingo Molnar <mingo@elte.hu>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Mark McLoughlin <markmc@redhat.com>, Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122229.00073.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(The odd files are a couple of exports: eventfd_signal/eventfd_fget and
 kick_process.  All GPL-only).

The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git master

Mark McLoughlin (1):
      lguest: add support for indirect ring entries

Matias Zabaljauregui (6):
      lguest: Segment selectors are 16-bit long. Fix lg_cpu.ss1 definition.
      lguest: map switcher with executable page table entries
      lguest: use native_set_* macros, which properly handle 64-bit entries when PAE is activated
      lguest: replace hypercall name LHCALL_SET_PMD with LHCALL_SET_PGD
      lguest: Add support for kvm_hypercall4()
      lguest: PAE support

Roel Kluin (1):
      lguest: beyond ARRAY_SIZE of cpu->arch.gdt

Rusty Russell (23):
      lguest: be paranoid about guest playing with device descriptors.
      lguest: cleanup passing of /dev/lguest fd around example launcher.
      lguest: clean up lguest_init_IRQ
      lguest: get more serious about wmb() in example Launcher code
      sched: export kick_process
      lguest: fix lguest wake on guest clock tick, or fd activity
      lguest: remove invalid interrupt forcing logic.
      lguest: fix race in halt code
      lguest: improve interrupt handling, speed up stream networking
      lguest: optimize by coding restore_flags and irq_enable in assembler.
      lguest: clean up example launcher compile flags.
      lguest: clean up length-used value in example launcher
      lguest: fix writev returning short on console output
      lguest: PAE fixes
      lguest: allow any process to send interrupts
      eventfd: export eventfd_signal and eventfd_fget for lguest
      lguest: use eventfds for device notification
      lguest: have example Launcher service all devices in separate threads
      lguest: remove obsolete LHREQ_BREAK call
      lguest: implement deferred interrupts in example Launcher
      lguest: avoid sending interrupts to Guest when no activity occurs.
      lguest: try to batch interrupts on network receive
      lguest: suppress notifications in example Launcher

 Documentation/lguest/Makefile         |    3 +-
 Documentation/lguest/lguest.c         | 1008 ++++++++++++---------------------
 Documentation/lguest/lguest.txt       |    1 -
 arch/x86/include/asm/lguest.h         |    7 +-
 arch/x86/include/asm/lguest_hcall.h   |   15 +-
 arch/x86/kernel/asm-offsets_32.c      |    1 +
 arch/x86/lguest/Kconfig               |    1 -
 arch/x86/lguest/boot.c                |  158 ++++--
 arch/x86/lguest/i386_head.S           |   60 ++-
 drivers/lguest/Kconfig                |    2 +-
 drivers/lguest/core.c                 |   30 +-
 drivers/lguest/hypercalls.c           |   14 +
 drivers/lguest/interrupts_and_traps.c |   57 ++-
 drivers/lguest/lg.h                   |   28 +-
 drivers/lguest/lguest_user.c          |  127 +++--
 drivers/lguest/page_tables.c          |  396 +++++++++++--
 drivers/lguest/segments.c             |    2 +-
 fs/eventfd.c                          |    3 +
 include/linux/lguest.h                |    4 +
 include/linux/lguest_launcher.h       |    3 +-
 kernel/sched.c                        |    1 +
 21 files changed, 1103 insertions(+), 818 deletions(-)

