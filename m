Return-Path: <linux-kernel-owner+w=401wt.eu-S933111Ab0AFXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab0AFXsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545Ab0AFXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:48:24 -0500
Received: from kroah.org ([198.145.64.141]:34547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab0AFXrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:47:40 -0500
Date: Wed, 6 Jan 2010 15:46:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.3
Message-ID: <20100106234629.GE1960@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.3 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/filesystems/ext4.txt             |    2 
 Makefile                                       |    2 
 arch/powerpc/kernel/align.c                    |   63 +++++-
 arch/x86/include/asm/msr.h                     |   19 +-
 arch/x86/include/asm/processor.h               |    2 
 arch/x86/include/asm/uv/uv_hub.h               |   86 +++++----
 arch/x86/kernel/amd_iommu_init.c               |   10 +
 arch/x86/kernel/apic/x2apic_uv_x.c             |   12 -
 arch/x86/kernel/ptrace.c                       |   16 -
 arch/x86/kvm/lapic.c                           |    1 
 arch/x86/kvm/paging_tmpl.h                     |   18 -
 arch/x86/lib/Makefile                          |    4 
 arch/x86/lib/msr-smp.c                         |  204 ++++++++++++++++++++++
 arch/x86/lib/msr.c                             |  227 +------------------------
 drivers/acpi/button.c                          |    7 
 drivers/acpi/ec.c                              |   10 -
 drivers/ata/pata_cmd64x.c                      |    2 
 drivers/ata/pata_hpt3x2n.c                     |   64 +++----
 drivers/bluetooth/btusb.c                      |    1 
 drivers/dma/at_hdmac.c                         |    4 
 drivers/dma/ioat/dma.c                         |    2 
 drivers/dma/ioat/dma.h                         |   18 +
 drivers/dma/ioat/dma_v2.c                      |   69 +++++--
 drivers/dma/ioat/dma_v2.h                      |    2 
 drivers/dma/ioat/dma_v3.c                      |   60 ++++--
 drivers/dma/ioat/registers.h                   |    1 
 drivers/edac/amd64_edac.c                      |  221 +++++++++++++-----------
 drivers/edac/amd64_edac.h                      |    9 
 drivers/gpu/drm/drm_crtc_helper.c              |    3 
 drivers/gpu/drm/radeon/atombios_crtc.c         |    6 
 drivers/gpu/drm/radeon/radeon_test.c           |    4 
 drivers/hwmon/sht15.c                          |    6 
 drivers/lguest/segments.c                      |    4 
 drivers/md/md.c                                |    8 
 drivers/media/video/ov511.c                    |    2 
 drivers/net/e100.c                             |    2 
 drivers/net/usb/rtl8150.c                      |    2 
 drivers/net/wireless/ath/ath5k/base.c          |    7 
 drivers/net/wireless/ath/ath9k/hw.h            |    2 
 drivers/net/wireless/ath/ath9k/mac.c           |    2 
 drivers/net/wireless/ath/ath9k/mac.h           |    3 
 drivers/net/wireless/ath/ath9k/main.c          |   14 +
 drivers/net/wireless/ath/ath9k/reg.h           |    4 
 drivers/net/wireless/ath/ath9k/xmit.c          |    6 
 drivers/net/wireless/b43/rfkill.c              |   10 -
 drivers/net/wireless/iwlwifi/iwl-3945.c        |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    2 
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h     |   14 -
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    7 
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    2 
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   23 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |    4 
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   11 -
 drivers/net/wireless/iwmc3200wifi/iwm.h        |    2 
 drivers/net/wireless/libertas/wext.c           |    2 
 drivers/net/wireless/orinoco/wext.c            |    6 
 drivers/net/wireless/rt2x00/rt61pci.c          |    5 
 drivers/platform/x86/acerhdf.c                 |    7 
 drivers/s390/block/dasd_diag.c                 |   19 +-
 drivers/scsi/ipr.c                             |    1 
 drivers/scsi/qla2xxx/qla_os.c                  |    6 
 drivers/scsi/scsi_transport_fc.c               |   17 +
 drivers/scsi/st.c                              |   23 +-
 drivers/scsi/st.h                              |    1 
 drivers/usb/core/hub.c                         |   58 +++---
 drivers/usb/core/sysfs.c                       |    6 
 drivers/usb/misc/appledisplay.c                |    4 
 drivers/usb/misc/emi62.c                       |    2 
 drivers/usb/musb/musb_gadget_ep0.c             |   14 +
 drivers/usb/serial/option.c                    |    5 
 drivers/xen/xenbus/xenbus_probe.c              |   42 +++-
 fs/cifs/connect.c                              |   13 -
 fs/ext4/ext4.h                                 |    6 
 fs/ext4/inode.c                                |   27 +-
 fs/ext4/super.c                                |    5 
 fs/namei.c                                     |    1 
 fs/quota/dquot.c                               |  213 +++++++++++++----------
 fs/stat.c                                      |   10 -
 fs/udf/super.c                                 |   32 ++-
 include/linux/cpumask.h                        |    2 
 include/linux/fs.h                             |    1 
 include/linux/quota.h                          |    5 
 include/linux/security.h                       |    7 
 include/net/ip.h                               |    1 
 include/net/ipv6.h                             |    8 
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    2 
 kernel/cpu.c                                   |   18 +
 kernel/cpuset.c                                |   16 -
 kernel/sched.c                                 |   40 ++--
 kernel/sched_fair.c                            |    3 
 kernel/sysctl.c                                |    5 
 kernel/time/clockevents.c                      |   18 +
 lib/dma-debug.c                                |    8 
 mm/Kconfig                                     |    1 
 mm/internal.h                                  |    3 
 mm/ksm.c                                       |   14 -
 mm/memcontrol.c                                |    8 
 mm/mlock.c                                     |    4 
 mm/oom_kill.c                                  |    2 
 mm/vmscan.c                                    |   18 +
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   21 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   19 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 
 net/ipv6/reassembly.c                          |    5 
 net/mac80211/ibss.c                            |    4 
 net/mac80211/mlme.c                            |    8 
 net/mac80211/tx.c                              |    1 
 net/mac80211/util.c                            |   12 +
 net/wireless/mlme.c                            |   13 +
 security/Makefile                              |    3 
 security/keys/keyctl.c                         |   10 +
 sound/mips/sgio2audio.c                        |    2 
 sound/pci/hda/patch_realtek.c                  |    6 
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c         |    2 
 sound/soc/codecs/wm8974.c                      |    2 
 sound/soc/codecs/wm9712.c                      |    3 
 sound/usb/usbaudio.c                           |    2 
 117 files changed, 1313 insertions(+), 804 deletions(-)

Alan Stern (2):
      USB: rename usb_configure_device
      USB: fix bugs in usb_(de)authorize_device

Alexey Starikovskiy (1):
      ACPI: EC: Fix MSI DMI detection

Amerigo Wang (1):
      'sysctl_max_map_count' should be non-negative

Andrey Borzenkov (1):
      orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts disabled

Bartlomiej Zolnierkiewicz (1):
      pata_cmd64x: fix overclocking of UDMA0-2 modes

Bob Copeland (1):
      ath5k: fix SWI calibration interrupt storm

Borislav Petkov (7):
      x86, msr: Unify rdmsr_on_cpus/wrmsr_on_cpus
      amd64_edac: unify MCGCTL ECC switching
      x86, msr: Add support for non-contiguous cpumasks
      x86, msr: msrs_alloc/free for CONFIG_SMP=n
      amd64_edac: fix driver instance freeing
      amd64_edac: make driver loading more robust
      amd64_edac: fix forcing module load/unload

Clemens Ladisch (2):
      sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer
      USB: emi62: fix crash when trying to load EMI 6|2 firmware

Daisuke Nishimura (1):
      memcg: avoid oom-killing innocent task in case of use_hierarchy

Dan Carpenter (1):
      V4L/DVB (13596): ov511.c typo: lock => unlock

Dan Williams (2):
      ioat3: fix p-disabled q-continuation
      ioat2,3: put channel hardware in known state at init

Daniel Mack (1):
      Libertas: fix buffer overflow in lbs_get_essid()

Dave Airlie (2):
      drm/radeon: fix build on 64-bit with some compilers.
      drm/radeon/kms: fix crtc vblank update for r600

David Howells (1):
      NOMMU: Optimise away the {dac_,}mmap_min_addr tests

Dmitry Monakhov (4):
      Add unlocked version of inode_add_bytes() function
      quota: decouple fs reserved space from quota reservation
      ext4: Convert to generic reserved quota's space management.
      ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)

Donny Kurnia (1):
      USB: option: support hi speed for modem Haier CE100

Eric Millbrandt (1):
      ASoC: Do not write to invalid registers on the wm9712.

FUJITA Tomonori (1):
      SCSI: st: fix mdata->page_order handling

Fang Wenqi (1):
      ext4: Update documentation to correct the inode_readahead_blks option name

Felix Fietkau (1):
      ath9k: fix missed error codes in the tx status check

Geert Uytterhoeven (1):
      Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME architecture support

Gertjan van Wingerde (1):
      rt2x00: Disable powersaving for rt61pci and rt2800pci.

Greg Kroah-Hartman (1):
      Linux 2.6.32.3

Guennadi Liakhovetski (1):
      ASoC: wm8974: fix a wrong bit definition

Hugh Dickins (1):
      ksm: fix mlockfreed to munlocked

Ingo Molnar (1):
      dma-debug: Fix bug causing build warning

Jan Kara (1):
      udf: Try harder when looking for VAT inode

Jeff Layton (1):
      cifs: NULL out tcon, pSesInfo, and srvTcp pointers when chasing DFS referrals

Joerg Roedel (1):
      x86/amd-iommu: Fix initialization failure panic

Johannes Berg (4):
      mac80211: fix WMM AP settings application
      cfg80211: fix race between deauth and assoc response
      iwlwifi: fix EEPROM/OTP reading endian annotations and a bug
      iwlwifi: fix more eeprom endian bugs

Jonathan Cameron (1):
      hwmon: (sht15) Off-by-one error in array index + incorrect constants

Julia Lawall (1):
      drivers/net/usb: Correct code taking the size of a pointer

Kleber Sacilotto de Souza (1):
      SCSI: ipr: fix EEH recovery

Larry Finger (1):
      b43: avoid PPC fault during resume

Linus Torvalds (1):
      x86/ptrace: make genregs[32]_get/set more robust

Luis R. Rodriguez (4):
      mac80211: fix propagation of failed hardware reconfigurations
      ath9k: wake hardware for interface IBSS/AP/Mesh removal
      ath9k: wake hardware during AMPDU TX actions
      mac80211: fix race with suspend and dynamic_ps_disable_work

Marcelo Tosatti (2):
      KVM: MMU: remove prefault from invlpg handler
      KVM: LAPIC: make sure IRR bitmap is scanned after vm load

Michael Reed (1):
      SCSI: qla2xxx: dpc thread can execute before scsi host has been added

Mike Christie (1):
      SCSI: fc class: fix fc_transport_init error handling

Mike Travis (1):
      x86: SGI UV: Fix writes to led registers on remote uv hubs

Neil Campbell (1):
      powerpc: Handle VSX alignment faults correctly in little-endian mode

NeilBrown (1):
      md: Fix unfortunate interaction with evms

Nicolas Ferre (1):
      dma: at_hdmac: correct incompatible type for argument 1 of 'spin_lock_bh'

Oliver Neukum (1):
      Bluetooth: Prevent ill-timed autosuspend in USB driver

Paolo Bonzini (3):
      xen: fix is_disconnected_device/exists_disconnected_device
      xen: improvement to wait_for_devices()
      xen: wait up to 5 minutes for device connetion

Patrick McHardy (2):
      ipv6: reassembly: use seperate reassembly queues for conntrack and local delivery
      netfilter: fix crashes in bridge netfilter caused by fragment jumps

Peter Zijlstra (4):
      sched: Fix task_hot() test order
      sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
      sched: Fix balance vs hotplug race
      sched: Sched_rt_periodic_timer vs cpu hotplug

Reinette Chatre (2):
      iwl3945: disable power save
      iwlwifi: fix 40MHz operation setting on cards that do not allow it

Rik van Riel (1):
      vmscan: do not evict inactive pages when skipping an active list scan

Roger Oksanen (1):
      e100: Fix broken cbs accounting due to missing memset.

Rusty Russell (2):
      cpumask: use modern cpumask style in drivers/edac/amd64_edac.c
      lguest: fix bug in setting guest GDT entry

Serge E. Hallyn (1):
      generic_permission: MAY_OPEN is not write access

Sergei Shtylyov (2):
      pata_hpt3x2n: fix clock turnaround
      USB: musb: gadget_ep0: avoid SetupEnd interrupt

Shaun Ruffell (1):
      dma-debug: Do not add notifier when dma debugging is disabled.

Stefan Bader (1):
      acerhdf: limit modalias matching to supported

Stefan Weinhuber (1):
      S390: dasd: support DIAG access for read-only devices

Sujith (3):
      mac80211: Fix IBSS merge
      ath9k: Fix TX queue draining
      ath9k: fix suspend by waking device prior to stop

Suresh Siddha (1):
      x86, cpuid: Add "volatile" to asm in native_cpuid()

Takashi Iwai (1):
      ALSA: hda - Fix missing capsrc_nids for ALC88x

Thomas Gleixner (1):
      clockevents: Prevent clockevent_devices list corruption on cpu hotplug

Vasanthakumar Thiagarajan (2):
      ath9k_hw: Fix possible OOB array indexing in gen_timer_index[] on 64-bit
      ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB and its shift value in 0x4054

WANG Cong (1):
      kernel/sysctl.c: fix the incomplete part of sysctl_max_map_count-should-be-non-negative.patch

Zhao Yakui (2):
      ACPI: Use the return result of ACPI lid notifier chain correctly
      drm: disable all the possible outputs/crtcs before entering KMS mode

Zhu Yi (2):
      iwmc3200wifi: fix array out-of-boundary access
      iwl3945: fix panic in iwl3945 driver

pancho horrillo (1):
      USB: Fix a bug on appledisplay.c regarding signedness

