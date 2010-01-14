Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980Ab0ANW07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0ANW07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0ANW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:26:58 -0500
Received: from cantor.suse.de ([195.135.220.2]:56903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0ANW05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:26:57 -0500
Date: Thu, 14 Jan 2010 14:25:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/52] 2.6.32.4-stable review
Message-ID: <20100114222551.GA7839@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.4 release.
There are 52 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Saturday, January 16, 22:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                  |    2 +-
 arch/alpha/kernel/osf_sys.c               |   19 +--
 arch/arm/include/asm/mman.h               |    3 +
 arch/arm/kernel/calls.S                   |    2 +-
 arch/arm/kernel/entry-common.S            |    4 +-
 arch/arm/kernel/sys_arm.c                 |   55 +-------
 arch/arm/mm/mmap.c                        |    3 +-
 arch/avr32/include/asm/syscalls.h         |    4 -
 arch/avr32/kernel/sys_avr32.c             |   31 ----
 arch/avr32/kernel/syscall-stubs.S         |    2 +-
 arch/blackfin/kernel/sys_bfin.c           |   33 ----
 arch/blackfin/mach-common/entry.S         |    2 +-
 arch/cris/kernel/sys_cris.c               |   30 +----
 arch/frv/kernel/sys_frv.c                 |   66 +--------
 arch/h8300/kernel/sys_h8300.c             |   83 +----------
 arch/h8300/kernel/syscalls.S              |    2 +-
 arch/ia64/ia32/sys_ia32.c                 |    3 +
 arch/ia64/kernel/sys_ia64.c               |   83 +----------
 arch/m32r/kernel/sys_m32r.c               |   24 ---
 arch/m32r/kernel/syscall_table.S          |    2 +-
 arch/m68k/kernel/sys_m68k.c               |   83 +---------
 arch/m68knommu/kernel/sys_m68k.c          |   38 +-----
 arch/m68knommu/kernel/syscalltable.S      |    2 +-
 arch/microblaze/kernel/sys_microblaze.c   |   38 +----
 arch/microblaze/kernel/syscall_table.S    |    2 +-
 arch/mips/kernel/linux32.c                |   19 +--
 arch/mips/kernel/syscall.c                |   32 +----
 arch/mn10300/include/asm/mman.h           |    5 +
 arch/mn10300/kernel/entry.S               |    2 +-
 arch/mn10300/kernel/sys_mn10300.c         |   36 +----
 arch/parisc/kernel/sys_parisc.c           |   30 +---
 arch/powerpc/include/asm/module.h         |    5 +
 arch/powerpc/kernel/syscalls.c            |   15 +--
 arch/powerpc/kernel/vmlinux.lds.S         |    3 +
 arch/s390/kernel/compat_linux.c           |   37 +----
 arch/s390/kernel/sys_s390.c               |   30 +----
 arch/score/kernel/sys_score.c             |   28 +---
 arch/sh/kernel/sys_sh.c                   |   28 +---
 arch/sh/mm/mmap.c                         |    3 +-
 arch/sparc/kernel/sys_sparc_32.c          |   64 +-------
 arch/sparc/kernel/sys_sparc_64.c          |   50 ++-----
 arch/sparc/kernel/systbls.h               |    1 -
 arch/sparc/kernel/systbls_32.S            |    4 +-
 arch/sparc/kernel/systbls_64.S            |    4 +-
 arch/um/kernel/syscall.c                  |   28 +---
 arch/um/sys-i386/shared/sysdep/syscalls.h |    4 -
 arch/x86/Kconfig.cpu                      |    2 +-
 arch/x86/ia32/ia32entry.S                 |    2 +-
 arch/x86/ia32/sys_ia32.c                  |   43 +-----
 arch/x86/include/asm/sys_ia32.h           |    3 -
 arch/x86/include/asm/syscalls.h           |    2 -
 arch/x86/kernel/sys_i386_32.c             |   27 +---
 arch/x86/kernel/sys_x86_64.c              |   17 +--
 arch/x86/kernel/syscall_table_32.S        |    2 +-
 arch/xtensa/include/asm/syscall.h         |    2 -
 arch/xtensa/include/asm/unistd.h          |    2 +-
 arch/xtensa/kernel/syscall.c              |   25 ---
 drivers/cpuidle/governors/menu.c          |   12 +-
 drivers/gpu/drm/ati_pcigart.c             |   10 +-
 drivers/gpu/drm/drm_bufs.c                |    4 +-
 drivers/gpu/drm/drm_pci.c                 |    8 +-
 drivers/gpu/drm/i915/i915_dma.c           |    5 +-
 drivers/gpu/drm/i915/i915_drv.h           |    1 +
 drivers/gpu/drm/i915/i915_gem.c           |   12 +-
 drivers/gpu/drm/i915/i915_reg.h           |    4 +
 drivers/gpu/drm/i915/intel_display.c      |  180 ++++++---------------
 drivers/gpu/drm/i915/intel_lvds.c         |    9 +
 drivers/hwmon/Kconfig                     |    2 +-
 drivers/hwmon/adt7462.c                   |    2 +-
 drivers/hwmon/coretemp.c                  |   16 ++-
 drivers/mmc/card/block.c                  |    8 +
 drivers/mmc/card/queue.c                  |   18 +-
 drivers/net/wireless/ath/ath5k/eeprom.c   |   32 ++++-
 drivers/net/wireless/ath/ath5k/eeprom.h   |    8 +
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 drivers/net/wireless/libertas/scan.c      |   22 +--
 drivers/rtc/rtc-cmos.c                    |    9 +-
 drivers/xen/manage.c                      |    8 +-
 fs/exofs/inode.c                          |   17 ++-
 fs/fcntl.c                                |  102 ++++++++-----
 fs/nfsd/vfs.c                             |    5 +-
 fs/quota/dquot.c                          |    3 +
 include/drm/drmP.h                        |    2 +-
 include/linux/syscalls.h                  |    4 +
 ipc/shm.c                                 |   31 ++--
 kernel/audit_tree.c                       |   13 +-
 kernel/cgroup.c                           |    1 -
 kernel/module.c                           |   45 ++++--
 kernel/signal.c                           |    3 +-
 kernel/sysctl.c                           |    2 +-
 lib/dma-debug.c                           |    7 +-
 lib/rational.c                            |    1 +
 mm/mmap.c                                 |   42 ++----
 mm/mremap.c                               |  241 +++++++++++++++++++----------
 mm/util.c                                 |   44 ++++++
 net/bridge/netfilter/ebtables.c           |    6 +
 net/ipv6/exthdrs.c                        |    7 +-
 net/mac80211/iface.c                      |   40 +++++-
 net/mac80211/mlme.c                       |    4 +-
 net/mac80211/rx.c                         |    8 +-
 net/mac80211/tx.c                         |    5 +-
 net/mac80211/util.c                       |   12 ++
 net/mac80211/wme.c                        |   89 ++++++++---
 net/mac80211/wme.h                        |    8 +-
 net/netfilter/nf_conntrack_ftp.c          |   18 +-
 net/sunrpc/auth_gss/auth_gss.c            |   17 ++-
 net/sunrpc/auth_gss/gss_krb5_mech.c       |    4 +-
 net/sunrpc/auth_gss/gss_mech_switch.c     |    2 +-
 net/sunrpc/svc_xprt.c                     |    3 +-
 net/wireless/reg.c                        |    2 +-
 sound/pci/ac97/ac97_patch.c               |    1 +
 sound/pci/atiixp.c                        |    1 +
 sound/pci/hda/patch_realtek.c             |    2 +-
 sound/soc/codecs/wm8350.c                 |    2 +-
 sound/soc/codecs/wm8510.c                 |   14 +-
 sound/soc/codecs/wm8940.c                 |   14 +-
 sound/soc/codecs/wm8974.c                 |   14 +-
 118 files changed, 867 insertions(+), 1514 deletions(-)
