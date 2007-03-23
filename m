Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbXCWU0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbXCWU0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXCWU0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:26:11 -0400
Received: from ns.suse.de ([195.135.220.2]:50594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbXCWU0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:26:09 -0400
Date: Fri, 23 Mar 2007 13:24:11 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, torvalds@osdl.org, stable@kernel.org
Subject: Linux 2.6.20.4
Message-ID: <20070323202411.GA4674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.20.4 kernel.
It contains a number of bugfixes and all 2.6.20 users are recommended to
upgrade.

The diffstat and short summary of the fixes are below.

I'll also be replying to this message with a copy of the patch between
2.6.20.3 and 2.6.20.4.

The updated 2.6.20.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
and can be browsed at the normal kernel.org git web browser:
        www.kernel.org/git/

thanks,

greg k-h
--------

 Makefile                             |    2 
 arch/ia64/kernel/iosapic.c           |    8 ++-
 arch/ia64/sn/kernel/irq.c            |   14 +++++-
 arch/sparc64/kernel/ktlb.S           |    8 +++
 arch/sparc64/kernel/tsb.S            |    1 
 arch/sparc64/lib/NGbzero.S           |    1 
 arch/sparc64/lib/NGmemcpy.S          |    2 
 arch/sparc64/lib/NGpage.S            |    2 
 arch/sparc64/mm/hugetlbpage.c        |    3 +
 arch/sparc64/mm/init.c               |   30 ++++++++++++-
 arch/um/include/os.h                 |    2 
 arch/um/os-Linux/sys-x86_64/Makefile |    2 
 arch/um/os-Linux/sys-x86_64/prctl.c  |   12 +++++
 arch/um/sys-x86_64/syscalls.c        |   76 ++++++++++++++++++++++++++---------
 arch/um/sys-x86_64/tls.c             |   11 +++--
 drivers/input/serio/i8042.c          |   20 ++++++---
 drivers/md/linear.c                  |    2 
 drivers/net/r8169.c                  |   10 ++--
 drivers/pci/probe.c                  |   45 ++++++++++++++------
 drivers/scsi/gdth.c                  |    2 
 drivers/scsi/st.c                    |   23 +++++-----
 drivers/scsi/st.h                    |    3 -
 drivers/usb/host/ehci-hub.c          |    4 +
 fs/nfs/inode.c                       |    3 -
 include/asm-sparc64/tsb.h            |    2 
 include/asm-um/processor-x86_64.h    |    6 +-
 include/asm-um/ptrace-x86_64.h       |    6 --
 include/linux/ktime.h                |    6 ++
 kernel/auditsc.c                     |   24 +++++------
 kernel/fork.c                        |    2 
 kernel/futex.c                       |    2 
 kernel/hrtimer.c                     |    6 ++
 mm/filemap.c                         |   46 ++++++++++++++++-----
 mm/madvise.c                         |    5 +-
 mm/oom_kill.c                        |    2 
 net/core/skbuff.c                    |    1 
 net/ipv4/cipso_ipv4.c                |    7 +--
 net/ipv4/devinet.c                   |    4 +
 net/ipv4/fib_trie.c                  |    2 
 net/ipv6/ipv6_sockglue.c             |    2 
 net/ipv6/tcp_ipv6.c                  |    1 
 net/irda/irttp.c                     |    1 
 net/netfilter/nfnetlink_log.c        |    8 ---
 net/xfrm/xfrm_state.c                |    6 +-
 sound/pci/hda/hda_intel.c            |   13 +++++
 45 files changed, 321 insertions(+), 117 deletions(-)

Summary of changes from v2.6.20.3 to v2.6.20.4
==============================================

Al Viro (1):
      fix deadlock in audit_log_task_context()

Alan Stern (1):
      EHCI: add delay to bus_resume before accessing ports

Alexey Dobriyan (1):
      Copy over mac_len when cloning an skb

Andy Isaacson (1):
      fix read past end of array in md/linear.c

Ankita Garg (1):
      oom fix: prevent oom from killing a process with children/sibling unkillable

David Miller (3):
      Fix sparc64 hugepage bugs
      Fix page allocation debugging on sparc64
      Fix niagara memory corruption

Dmitry Torokhov (3):
      Input: i8042 - really suppress ACK/NAK during panic blink
      Input: i8042 - fix AUX IRQ delivery check
      Input: i8042 - another attempt to fix AUX delivery checks

Evgeniy Polyakov (1):
      Fix rtm_to_ifaddr() error return.

Francois Romieu (1):
      r8169: fix a race between PCI probe and dev_open

Greg Kroah-Hartman (1):
      Linux 2.6.20.4

Ingo Molnar (1):
      futex: PI state locking fix

Jan Beulich (1):
      adjust legacy IDE resource setting (v2)

Jeff Dike (1):
      UML - arch_prctl should set thread fs

Joerg Dorchain (1):
      gdth: fix oops in gdth_copy_cmd()

Joy Latten (1):
      Fix extraneous IPSEC larval SA creation

KAMEZAWA Hiroyuki (1):
      IA64: fix NULL pointer in ia64/irq_chip-mask/unmask function

Kai Makisara (1):
      st: fix Tape dies if wrong block size used, bug 7919

Masayuki Nakagawa (1):
      Fix ipv6 flow label inheritance

Michal Miroslaw (1):
      NETFILTER: nfnetlink_log: fix reference counting

Nick Piggin (1):
      mm: fix madvise infinine loop

Olaf Kirch (1):
      Fix another NULL pointer deref in ipv6_sockglue.c

Paul Moore (1):
      NetLabel: Verify sensitivity level has a valid CIPSO mapping

Robert Olsson (1):
      Fix GFP_KERNEL with preemption disabled in fib_trie

Samuel Ortiz (1):
      IrDA: irttp_dup spin_lock initialisation

Takashi Iwai (1):
      hda-intel - Fix codec probe with ATI controllers

Thomas Gleixner (2):
      hrtimer: prevent overrun DoS in hrtimer_forward()
      fix MTIME_SEC_MAX on 32-bit

Trond Myklebust (1):
      nfs: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files

Zach Brown (1):
      dio: invalidate clean pages before dio write

Zilvinas Valinskas (1):
      initialise pi_lock if CONFIG_RT_MUTEXES=N

