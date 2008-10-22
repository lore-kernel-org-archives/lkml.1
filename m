Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbYJVFCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbYJVFCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYJVFCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:02:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:49180 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYJVFCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:02:14 -0400
Subject: [git pull] Please pull from powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 16:01:57 +1100
Message-Id: <1224651717.7654.332.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's some additions to yesterday's pull request. Mostly things that
slipped through the cracks, for example, for the hvc_console work
there was some confusion as to who was going to merge it, and the
kdump bits I mentioned yesterday that were getting some
rebasing/massaging. The rest is either trivial enough or bug fixes,

That should now bit it for the "features" for this merge window

The following changes since commit a02efb906d12c9d4eb2ab7c59049ba9545e5412d:
  Benjamin Herrenschmidt (1):
        Merge commit 'origin' into master

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git master

Becky Bruce (1):
      powerpc: Move memory size print into common show_cpuinfo for 32-bit

David Gibson (1):
      powerpc: Further compile fixup for STRICT_MM_TYPECHECKS

Hendrik Brueckner (5):
      hvc_console: Add a hangup notifier for backends
      hvc_console: Add tty driver flag TTY_DRIVER_RESET_TERMIOS
      hvc_console: Fix loop if put_char() returns 0
      hvc_console: Add support for tty window resizing
      hvc_console: Remove __devexit annotation of hvc_remove()

Jon Tollefson (1):
      powerpc: Don't use a 16G page if beyond mem= limits

Michael Neuling (1):
      powerpc: Remove empty #else from signal_64.c

Mike Ditto (1):
      powerpc: Add del_node() for early boot code to prune inapplicable devices.

Mohan Kumar M (1):
      powerpc: Support for relocatable kdump kernel

 Documentation/kdump/kdump.txt                  |   14 +++-
 arch/powerpc/Kconfig                           |   10 +--
 arch/powerpc/boot/libfdt-wrapper.c             |    6 ++
 arch/powerpc/boot/ops.h                        |    6 ++
 arch/powerpc/include/asm/kdump.h               |   17 +++--
 arch/powerpc/kernel/crash_dump.c               |    2 +
 arch/powerpc/kernel/head_64.S                  |   39 +++++++++--
 arch/powerpc/kernel/iommu.c                    |   69 ++++++++++---------
 arch/powerpc/kernel/machine_kexec.c            |    2 +
 arch/powerpc/kernel/machine_kexec_64.c         |   13 +++-
 arch/powerpc/kernel/misc_64.S                  |    9 ++-
 arch/powerpc/kernel/pci-common.c               |    3 +-
 arch/powerpc/kernel/setup-common.c             |    7 ++
 arch/powerpc/kernel/signal_64.c                |    2 -
 arch/powerpc/mm/hash_utils_64.c                |    6 +-
 arch/powerpc/platforms/85xx/ksi8560.c          |    4 -
 arch/powerpc/platforms/85xx/mpc85xx_ads.c      |    4 -
 arch/powerpc/platforms/85xx/mpc85xx_cds.c      |    4 -
 arch/powerpc/platforms/85xx/sbc8548.c          |    4 -
 arch/powerpc/platforms/85xx/sbc8560.c          |    4 -
 arch/powerpc/platforms/85xx/stx_gp3.c          |    4 -
 arch/powerpc/platforms/85xx/tqm85xx.c          |    4 -
 arch/powerpc/platforms/86xx/gef_sbc610.c       |    2 -
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c     |    2 -
 arch/powerpc/platforms/86xx/sbc8641d.c         |    2 -
 arch/powerpc/platforms/cell/ras.c              |    6 +-
 arch/powerpc/platforms/embedded6xx/c2k.c       |    3 -
 arch/powerpc/platforms/embedded6xx/prpmc2800.c |    3 -
 arch/powerpc/platforms/pseries/iommu.c         |    6 +-
 drivers/char/hvc_console.c                     |   86 ++++++++++++++++++++----
 drivers/char/hvc_console.h                     |   12 +++-
 drivers/char/hvc_irq.c                         |    5 ++
 drivers/char/hvc_iseries.c                     |    1 +
 drivers/char/hvc_vio.c                         |    1 +
 drivers/char/hvc_xen.c                         |    1 +
 drivers/char/virtio_console.c                  |    1 +
 36 files changed, 238 insertions(+), 126 deletions(-)


