Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbZE0UVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbZE0UVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932296AbZE0UVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:21:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46004 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762852AbZE0UVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:21:10 -0400
Date: Wed, 27 May 2009 22:21:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, hpa@zytor.com, seto.hidetoshi@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Please pull MCE 32bit merge tree
Message-ID: <20090527202109.GA8008@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull the mce3-32bitmerge tree that enables the 64bit machine
check code on 32bit x86 too, as earlier discussed.
It also includes the machine check injector because I needed that
for testing.

It is based on the mce3 tree I offered earlier.

This is the patch kit I posted yesterday. There were some reviews, but
no negative comments.

This should be merged for 2.6.31

Thanks,
-Andi

The following changes since commit 509116152e7c09ed2e0e8b2dae241b89d9d0e699:
  Ingo Molnar (1):
        x86, mce: print number of MCE banks

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce3-32bitmerge

Andi Kleen (17):
      x86: MCE: Initial steps to make 64bit mce code 32bit clean
      x86: MCE: Implement the PPro bank 0 quirk in the 64bit machine check code
      x86: MCE: Port K7 bank 0 quirk to 64bit mce code
      x86: MCE: Use a call vector to call the 64bit mce handler
      x86: MCE: Rename 64bit mce_dont_init to mce_disabled
      x86: MCE: Move mce_disabled option into common 64bit/64bit code
      x86: MCE: Remove machine check handler idle notify on 64bit
      x86: MCE: Remove oops_begin() use in 64bit machine check
      x86: MCE: Remove unused stop/restart_mce on 32bit
      x86: MCE: Use 64bit machine check code on 32bit
      x86: MCE: Deprecate old 32bit machine check code
      x86: MCE: Enable MCE_INTEL for 32bit new MCE
      x86: MCE: Enable MCE_AMD for 32bit NEW_MCE
      x86: MCE: Document new 32bit mcelog requirement in Documentation/Changes
      Export add_timer_on for modules
      x86: MCE: Add MSR read wrappers for easier error injection
      x86: MCE: Add basic error injection infrastructure

 Documentation/Changes                      |   15 ++
 Documentation/feature-removal-schedule.txt |   10 +
 arch/x86/Kconfig                           |   45 +++++-
 arch/x86/include/asm/entry_arch.h          |    6 +-
 arch/x86/include/asm/hardirq.h             |    2 +-
 arch/x86/include/asm/irq_vectors.h         |    5 +-
 arch/x86/include/asm/mce.h                 |    7 +-
 arch/x86/kernel/apic/apic.c                |    4 +-
 arch/x86/kernel/apic/nmi.c                 |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile        |    4 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |  126 +++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c           |  265 +++++++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce.h           |   19 ++-
 arch/x86/kernel/cpu/mcheck/p5.c            |    5 +
 arch/x86/kernel/cpu/mcheck/threshold.c     |    2 +-
 arch/x86/kernel/entry_64.S                 |    4 +-
 arch/x86/kernel/irq.c                      |    4 +-
 arch/x86/kernel/irqinit_32.c               |    6 +-
 arch/x86/kernel/signal.c                   |    4 +-
 arch/x86/kernel/traps.c                    |    6 +-
 kernel/timer.c                             |    1 +
 21 files changed, 412 insertions(+), 130 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-inject.c
-- 
ak@linux.intel.com -- Speaking for myself only.
