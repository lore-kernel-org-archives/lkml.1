Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZESV4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZESV4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbZESV4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:56:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZESV4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:56:35 -0400
Date: Tue, 19 May 2009 23:56:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [x86] [MCE] Updated 32bit merge for tip x86 mce2 branch
Message-ID: <20090519215631.GA15626@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchkit finishes the 32bit/64bit merge of the MCE code 
that is in the x86 tip x86/mce2 branch.

This is all based on earlier patches I posted to linux-kernel several
times for merging 32bit/64bit 

I first fixed some bugs in mce2 (make it compile and some other problems)
and then forward ported my old 32bit merge patches on top of it.

The 32bit merge patches port all the bug workarounds in the 32bit
code to the 64bit code and then enable the 64bit mce code
for 32bit too.

This is currently a CONFIG option for easier forward-backwards
testing, but that CONFIG will go away after one major release.

I also added the basic MCE inject infrastructure because I needed
that for testing. 

The branch needs a rebase for HEAD and a merge for some bug fixes in linus'
tree, but that's easily done (I didn't do it so far)

Also my fixes for mce2 could be collapsed into the earlier changes
there (I didn't do this to make it clear what I changed), feel free to do that.
I also reverted one patch where the patch author agreed it should
be reverted.

I addressed all feedback I got on earlier versions of this I believe.

Could this tree please be merged into tip and enabled for linux-next?

I will post the other pending MCE improvements on top then once 
that is in.

That's all 2.6.31 material.

Thanks,

-Andi

The following changes since commit dd9869965a301d0f35e32c42eb87d5f94883443a:
  Ingo Molnar (1):
        x86, mce: print number of MCE banks

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git mce-32bit-merge

Andi Kleen (20):
      x86: MCE: Make mce_amd_64.c compile again
      Revert "x86, mce: Add mce=nopoll option to disable timer polling"
      x86: MCE: Move ifdef X86_64 to the beginning of the file
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
 Documentation/feature-removal-schedule.txt |   12 +-
 Documentation/x86/x86_64/boot-options.txt  |    2 -
 arch/x86/Kconfig                           |   45 ++++-
 arch/x86/include/asm/entry_arch.h          |    6 +-
 arch/x86/include/asm/hardirq.h             |    2 +-
 arch/x86/include/asm/irq_vectors.h         |    5 +-
 arch/x86/include/asm/mce.h                 |    9 +-
 arch/x86/kernel/apic/apic.c                |    4 +-
 arch/x86/kernel/apic/nmi.c                 |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile        |    4 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c    |  126 +++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c           |  277 +++++++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce.h           |   19 ++-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |   10 +-
 arch/x86/kernel/cpu/mcheck/p5.c            |    5 +
 arch/x86/kernel/cpu/mcheck/threshold.c     |    2 +-
 arch/x86/kernel/entry_64.S                 |    4 +-
 arch/x86/kernel/irq.c                      |    4 +-
 arch/x86/kernel/irqinit_32.c               |    6 +-
 arch/x86/kernel/signal.c                   |    4 +-
 arch/x86/kernel/traps.c                    |    4 +-
 kernel/timer.c                             |    1 +
 23 files changed, 421 insertions(+), 147 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-inject.c
