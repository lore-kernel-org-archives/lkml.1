Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab0BYRwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:52:19 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:34459 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab0BYRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:52:16 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 25 Feb 2010 10:51:43 -0700
X-Google-Sender-Auth: 25101203b01d890e
Message-ID: <fa686aa41002250951s7bc64063wf227e5efbb406d66@mail.gmail.com>
Subject: [git pull] OF device tree rework for 2.6.34
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
       microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michal Simek <michal.simek@petalogix.com>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a bunch of device tree rework.  This has also been simmering
in linux-next for a while now.  Most of this is merging PowerPC &
Microblaze code with a sprinkling of SPARC changes, although there is
a small bit of minor rework throughout the drivers tree, all pretty
much powerpc specific stuff.

Cheers,
g.

The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

David Gibson (1):
      of/flattree: Make the kernel accept ePAPR style phandle information

Grant Likely (30):
      Merge commit 'v2.6.32-rc8'
      of/flattree: merge find_flat_dt_string and initial_boot_params
      of/flattree: merge of_scan_flat_dt
      of/flattree: merge of_get_flat_dt_root
      of/flattree: remove __init annotations from the header file
      of/flattree: merge of_get_flat_dt_prop
      of/flattree: Merge of_flat_dt_is_compatible
      of/flattree: Merge unflatten_dt_node
      of/flattree: Merge unflatten_device_tree
      of: merge prom_{add,remove,modify}_property
      of: remove special case definition of of_read_ulong()
      of/flattree: Merge early_init_dt_check_for_initrd()
      of/flattree: Merge earlyinit_dt_scan_root()
      of/flattree: merge dt_mem_next_cell
      of/flattree: eliminate cell_t typedef
      of/flattree: merge early_init_dt_scan_chosen()
      of: merge machine_is_compatible()
      of: Merge of_node_get() and of_node_put()
      of: unify phandle name in struct device_node
      Merge commit 'v2.6.33-rc5' into secretlab/test-devicetree
      microblaze: remove early_init_dt_scan_cpus() and phyp_dump_*()
      of: merge of_attach_node() & of_detach_node()
      of: add 'of_' prefix to machine_is_compatible()
      of/flattree: merge early_init_dt_scan_memory() common code
      of: Remove old and misplaced function declarations
      of: put default string compare and #a/s-cell values into common header
      of: remove unused extern reference to devtree_lock
      of: move definition of of_chosen into common code.
      of/sparc: Remove sparc-local declaration of allnodes and devtree_lock
      of: remove undefined request_OF_resource & release_OF_resource

Jeremy Kerr (12):
      of: merge of_find_node_by_phandle
      of: include linux/proc_fs.h
      of: make set_node_proc_entry private to proc_devtree.c
      proc_devtree: include linux/of.h
      of/flattree: use callback to setup initrd from /chosen
      of/flattree: use OF_ROOT_NODE_{SIZE,ADDR}_CELLS DEFAULT for fdt parsing
      of: use __be32 for cell value accessors
      of: assume big-endian properties, adding conversions where necessary
      of/flattree: endian-convert members of boot_param_header
      proc_devtree: fix THIS_MODULE without module.h
      of: protect linux/of.h with CONFIG_OF
      of/flattree: Don't assume HAVE_LMB

 arch/microblaze/Kconfig                       |    1 +
 arch/microblaze/include/asm/prom.h            |   20 -
 arch/microblaze/kernel/of_platform.c          |    2 +-
 arch/microblaze/kernel/prom.c                 |  990 +------------------------
 arch/powerpc/Kconfig                          |    1 +
 arch/powerpc/include/asm/prom.h               |   18 -
 arch/powerpc/kernel/of_platform.c             |    2 +-
 arch/powerpc/kernel/pci_64.c                  |    2 +-
 arch/powerpc/kernel/prom.c                    |  887 ++---------------------
 arch/powerpc/platforms/85xx/xes_mpc85xx.c     |    4 +-
 arch/powerpc/platforms/cell/cbe_powerbutton.c |    2 +-
 arch/powerpc/platforms/cell/ras.c             |    2 +-
 arch/powerpc/platforms/cell/spu_manage.c      |    6 +-
 arch/powerpc/platforms/pasemi/cpufreq.c       |    4 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c  |   14 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c  |   14 +-
 arch/powerpc/platforms/powermac/feature.c     |    2 +-
 arch/powerpc/platforms/powermac/pfunc_core.c  |    2 +-
 arch/powerpc/platforms/powermac/smp.c         |   12 +-
 arch/powerpc/platforms/powermac/time.c        |    8 +-
 arch/powerpc/platforms/powermac/udbg_scc.c    |    6 +-
 arch/powerpc/sysdev/grackle.c                 |    4 +-
 arch/sparc/kernel/devices.c                   |    2 +-
 arch/sparc/kernel/of_device_32.c              |    2 +-
 arch/sparc/kernel/of_device_64.c              |    2 +-
 arch/sparc/kernel/prom.h                      |    3 -
 arch/sparc/kernel/prom_common.c               |   18 +-
 arch/sparc/kernel/smp_64.c                    |    2 +-
 drivers/char/hvc_beat.c                       |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c       |   44 +-
 drivers/macintosh/adb.c                       |    4 +-
 drivers/macintosh/therm_pm72.c                |    8 +-
 drivers/macintosh/therm_windtunnel.c          |    2 +-
 drivers/macintosh/via-pmu-backlight.c         |    8 +-
 drivers/macintosh/via-pmu.c                   |    8 +-
 drivers/macintosh/windfarm_core.c             |    6 +-
 drivers/macintosh/windfarm_cpufreq_clamp.c    |    6 +-
 drivers/macintosh/windfarm_lm75_sensor.c      |    6 +-
 drivers/macintosh/windfarm_max6690_sensor.c   |    6 +-
 drivers/macintosh/windfarm_pm112.c            |    2 +-
 drivers/macintosh/windfarm_pm121.c            |    2 +-
 drivers/macintosh/windfarm_pm81.c             |    4 +-
 drivers/macintosh/windfarm_pm91.c             |    2 +-
 drivers/macintosh/windfarm_smu_sensors.c      |    6 +-
 drivers/net/mace.c                            |    2 +-
 drivers/of/Kconfig                            |    8 +
 drivers/of/Makefile                           |    1 +
 drivers/of/base.c                             |  318 ++++++++-
 drivers/of/fdt.c                              |  590 +++++++++++++++
 drivers/of/gpio.c                             |   13 +-
 drivers/of/of_i2c.c                           |    4 +-
 drivers/of/of_mdio.c                          |    8 +-
 drivers/of/of_spi.c                           |    6 +-
 drivers/sbus/char/openprom.c                  |   10 +-
 drivers/serial/pmac_zilog.c                   |    6 +-
 drivers/video/aty/aty128fb.c                  |   14 +-
 drivers/video/aty/atyfb_base.c                |   10 +-
 drivers/video/aty/radeon_backlight.c          |    6 +-
 fs/proc/proc_devtree.c                        |    7 +-
 include/linux/of.h                            |   62 ++-
 include/linux/of_fdt.h                        |   75 ++-
 sound/aoa/fabrics/layout.c                    |    2 +-
 sound/ppc/awacs.c                             |   24 +-
 sound/ppc/burgundy.c                          |    4 +-
 sound/ppc/pmac.c                              |   18 +-
 sound/soc/fsl/efika-audio-fabric.c            |    2 +-
 sound/soc/fsl/pcm030-audio-fabric.c           |    2 +-
 67 files changed, 1244 insertions(+), 2096 deletions(-)
 create mode 100644 drivers/of/fdt.c


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
