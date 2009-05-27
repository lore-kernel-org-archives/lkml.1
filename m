Return-Path: <linux-kernel-owner+w=401wt.eu-S934011AbZE0UYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbZE0UYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763957AbZE0UYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:24:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42167 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763893AbZE0UYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:24:32 -0400
Date: Wed, 27 May 2009 22:24:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, hpa@zytor.com, seto.hidetoshi@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Please pull mce3-improvements tree
Message-ID: <20090527202427.GA8073@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the x86 machine check improvements tree that I posted yesterday.
I addressed the review comments and did some minor changes.  I'm
not reposting everything as patches because the changes are quite
minor.

This is all ready for merging now. Most of these patches
are quite old and have been extensively reviewed.

It is based on the mce3-32bitmerge tree that I offered earlier.

Please merge this for 2.6.31

Thanks,
-Andi

The following changes since commit 4f56437b3a2b2a622685574d12dfce9e1fb846ae:
  Andi Kleen (1):
        x86: MCE: Add basic error injection infrastructure

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3-improvements

Andi Kleen (27):
      x86: MCE: Synchronize core after machine check handling
      x86: MCE: Use extended sysattrs for the check_interval attribute.
      x86: MCE: Add machine check exception count in /proc/interrupts
      x86: Fix panic with interrupts off (needed for MCE)
      x86: MCE: Log corrected errors when panicing
      x86: MCE: Remove unused mce_events variable
      x86: MCE: Rename and align out2 label
      x86: MCE: Implement bootstrapping for machine check wakeups
      x86: MCE: Remove TSC print heuristic
      x86: MCE: Drop BKL in mce_open
      x86: MCE: Add table driven machine check grading
      x86: MCE: Check early in exception handler if panic is needed
      x86: MCE: Implement panic synchronization
      x86: MCE: Switch x86 machine check handler to Monarch election. v2
      x86: MCE: Store record length into memory struct mce anchor
      x86: MCE: Default to panic timeout for machine checks v3
      x86: MCE: Improve documentation
      x86: MCE: Support more than 256 CPUs in struct mce
      x86: MCE: Extend struct mce user interface with more information.
      x86: MCE: Add MCE poll count to /proc/interrupts
      x86: MCE: Don't print backtrace on machine checks with DEBUG_BUGVERBOSE
      x86: MCE: Implement new status bits v2
      x86: MCE: Print header/footer only once for multiple MCEs
      x86: MCE: Make non Monarch panic message "Fatal machine check" too v2
      x86: MCE: Rename mce_notify_user to mce_notify_irq
      x86: MCE: Define MCE_VECTOR
      x86: MCE: Support action-optional machine checks v2

Huang Ying (2):
      x86: MCE: Improve mce_get_rip v3
      x86: MCE: Export MCE severities coverage via debugfs

Thomas Gleixner (1):
      x86: MCE: Remove mce_init unused argument

 Documentation/x86/x86_64/boot-options.txt |    8 +-
 Documentation/x86/x86_64/machinecheck     |    8 +-
 arch/x86/include/asm/entry_arch.h         |    1 +
 arch/x86/include/asm/hw_irq.h             |    2 +
 arch/x86/include/asm/irq_vectors.h        |   14 +-
 arch/x86/include/asm/mce.h                |   33 +-
 arch/x86/kernel/cpu/mcheck/Makefile       |    1 +
 arch/x86/kernel/cpu/mcheck/mce-inject.c   |   12 +-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   15 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  218 ++++++++
 arch/x86/kernel/cpu/mcheck/mce.c          |  833 ++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/entry_64.S                |    7 +
 arch/x86/kernel/irq.c                     |   14 +
 arch/x86/kernel/irqinit_32.c              |    3 +
 arch/x86/kernel/irqinit_64.c              |    7 +
 arch/x86/kernel/signal.c                  |    2 +-
 arch/x86/kernel/smp.c                     |   28 +-
 kernel/panic.c                            |    3 +-
 19 files changed, 1048 insertions(+), 163 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-internal.h
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-severity.c

-- 
ak@linux.intel.com -- Speaking for myself only.
