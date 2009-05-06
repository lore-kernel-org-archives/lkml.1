Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbZEFVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbZEFVyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbZEFVxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:53:30 -0400
Received: from kroah.org ([198.145.64.141]:56822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbZEFVx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:53:28 -0400
Date: Wed, 6 May 2009 14:50:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/58] 2.6.29.3-stable review
Message-ID: <20090506215017.GA21981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.29.3 release.
There are 58 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, May 8, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.3-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                             |    2 +-
 arch/powerpc/include/asm/processor.h |   19 ++++
 arch/powerpc/kernel/signal.c         |    4 +-
 arch/powerpc/kernel/signal.h         |    2 +-
 arch/powerpc/kernel/signal_32.c      |    4 +-
 arch/powerpc/kernel/signal_64.c      |    2 +-
 arch/x86/kernel/xsave.c              |    4 +-
 arch/x86/kvm/mmu.c                   |    2 +-
 arch/x86/kvm/x86.c                   |    5 +
 arch/x86/mm/kmmio.c                  |    2 +-
 arch/x86/pci/mmconfig-shared.c       |    6 +-
 block/genhd.c                        |   12 ++-
 drivers/acpi/acpica/rscreate.c       |   27 +-----
 drivers/char/hw_random/virtio-rng.c  |    4 +-
 drivers/crypto/ixp4xx_crypto.c       |  182 ++++++++++++----------------------
 drivers/gpu/drm/i915/i915_drv.h      |    4 +-
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    9 ++
 drivers/ide/cs5536.c                 |    1 +
 drivers/net/b44.c                    |    2 +-
 drivers/net/forcedeth.c              |    3 +
 drivers/net/mv643xx_eth.c            |   24 +++--
 drivers/net/wireless/ath5k/debug.c   |    2 +-
 drivers/net/wireless/ath9k/main.c    |    5 -
 drivers/net/wireless/b43/dma.c       |   50 ++++++++--
 drivers/net/wireless/rndis_wlan.c    |   14 ++-
 drivers/pci/dmar.c                   |   11 ++-
 drivers/pci/intel-iommu.c            |    8 ++-
 drivers/pci/quirks.c                 |    1 +
 drivers/platform/x86/thinkpad_acpi.c |   41 ++++----
 drivers/usb/serial/usb-serial.c      |   99 +++++++++++++------
 drivers/usb/storage/unusual_devs.h   |    6 +
 fs/Makefile                          |    2 +-
 fs/bio.c                             |    3 +
 fs/compat.c                          |   27 +++++-
 fs/exec.c                            |   43 +++++---
 fs/fs_struct.c                       |  170 +++++++++++++++++++++++++++++++
 fs/internal.h                        |    8 ++-
 fs/namei.c                           |    7 --
 fs/namespace.c                       |   60 -----------
 fs/nfsd/nfssvc.c                     |    7 +-
 fs/proc/array.c                      |   13 ++-
 fs/proc/base.c                       |   55 ++++-------
 fs/proc/meminfo.c                    |    2 +-
 fs/proc/task_mmu.c                   |    4 +
 fs/proc/task_nommu.c                 |    2 +-
 include/drm/drm_pciids.h             |    1 +
 include/linux/fs_struct.h            |    7 +-
 include/linux/genhd.h                |    1 +
 include/linux/kvm.h                  |    2 +
 include/linux/mman.h                 |    9 +-
 include/linux/pci_regs.h             |    2 +-
 kernel/exec_domain.c                 |   22 ----
 kernel/exit.c                        |   34 +------
 kernel/fork.c                        |   62 +++++-------
 kernel/ptrace.c                      |    4 +-
 kernel/sched.c                       |    2 +-
 kernel/time/tick-common.c            |   12 ++-
 mm/madvise.c                         |    8 ++
 mm/mmap.c                            |   12 +-
 mm/nommu.c                           |   13 ++-
 mm/swap.c                            |   46 ---------
 net/mac80211/mlme.c                  |    2 +-
 net/mac80211/rx.c                    |   13 ++-
 scripts/mod/modpost.c                |    1 +
 security/selinux/hooks.c             |    1 +
 sound/soc/codecs/wm8580.c            |    2 +-
 sound/usb/usx2y/us122l.c             |   12 ++-
 virt/kvm/kvm_main.c                  |   11 +-
 69 files changed, 682 insertions(+), 558 deletions(-)
