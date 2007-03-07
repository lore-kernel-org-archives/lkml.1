Return-Path: <linux-kernel-owner+w=401wt.eu-S1422886AbXCGRhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422886AbXCGRhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422965AbXCGRgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:36:42 -0500
Received: from mx1.suse.de ([195.135.220.2]:45560 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422948AbXCGRgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:36:11 -0500
Date: Wed, 7 Mar 2007 09:34:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 000/101] 2.6.20-stable review
Message-ID: <20070307173420.GA24957@kroah.com>
References: <20070307171035.150802805@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307171035.150802805@mini.kroah.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:10:35AM -0800, Greg KH wrote:
> After many weeks of backlogs, I've finally flushed out all of the
> pending -stable patches, bringing this series to a whopping 101 patches
> pending for the next 2.6.20.2 release.

Oh, forgot to announce, but the whole thing can be found in a patch at:
	kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.20.2-rc1.gz

And here's the diffstat below if anyone is curious.

thanks,

greg k-h

------------
 Makefile                                       |    2 
 arch/i386/kernel/cpu/mtrr/if.c                 |   33 +++++++-----
 arch/i386/kernel/signal.c                      |    6 +-
 arch/i386/kernel/sysenter.c                    |    2 
 arch/ia64/Kconfig                              |    1 
 arch/ia64/kernel/crash.c                       |   11 ++--
 arch/ia64/kernel/machine_kexec.c               |    2 
 arch/m32r/kernel/process.c                     |    2 
 arch/m32r/kernel/signal.c                      |   26 +--------
 arch/powerpc/kernel/head_64.S                  |    2 
 arch/ppc/kernel/ppc_ksyms.c                    |    2 
 arch/sparc64/kernel/of_device.c                |   40 ++++++++++++++-
 arch/um/os-Linux/sigio.c                       |   38 +++++++-------
 arch/x86_64/ia32/ia32_signal.c                 |    7 ++
 arch/x86_64/ia32/ptrace32.c                    |    1 
 block/ll_rw_blk.c                              |    2 
 drivers/Makefile                               |    2 
 drivers/ata/ahci.c                             |   14 +++++
 drivers/ata/ata_generic.c                      |    4 +
 drivers/ata/ata_piix.c                         |    4 +
 drivers/ata/pata_ali.c                         |    6 ++
 drivers/ata/pata_amd.c                         |   10 +++
 drivers/ata/pata_atiixp.c                      |    4 +
 drivers/ata/pata_cmd64x.c                      |    6 ++
 drivers/ata/pata_cs5520.c                      |    7 ++
 drivers/ata/pata_cs5530.c                      |    6 ++
 drivers/ata/pata_cs5535.c                      |    4 +
 drivers/ata/pata_cypress.c                     |    4 +
 drivers/ata/pata_efar.c                        |    4 +
 drivers/ata/pata_hpt366.c                      |    7 ++
 drivers/ata/pata_hpt3x3.c                      |    6 ++
 drivers/ata/pata_it821x.c                      |    6 ++
 drivers/ata/pata_jmicron.c                     |    8 +++
 drivers/ata/pata_marvell.c                     |    4 +
 drivers/ata/pata_mpiix.c                       |    4 +
 drivers/ata/pata_netcell.c                     |    4 +
 drivers/ata/pata_ns87410.c                     |    4 +
 drivers/ata/pata_oldpiix.c                     |    4 +
 drivers/ata/pata_opti.c                        |    4 +
 drivers/ata/pata_optidma.c                     |    4 +
 drivers/ata/pata_pdc202xx_old.c                |    4 +
 drivers/ata/pata_radisys.c                     |    4 +
 drivers/ata/pata_rz1000.c                      |    6 ++
 drivers/ata/pata_sc1200.c                      |    4 +
 drivers/ata/pata_serverworks.c                 |    6 ++
 drivers/ata/pata_sil680.c                      |    8 +++
 drivers/ata/pata_sis.c                         |    4 +
 drivers/ata/pata_triflex.c                     |    4 +
 drivers/ata/pata_via.c                         |    6 ++
 drivers/ata/sata_sil.c                         |   10 +++
 drivers/ata/sata_sil24.c                       |    2 
 drivers/block/pktcdvd.c                        |    2 
 drivers/char/agp/intel-agp.c                   |   14 +++--
 drivers/char/specialix.c                       |    2 
 drivers/char/tty_io.c                          |   14 +++++
 drivers/hid/hid-core.c                         |    5 -
 drivers/ide/ide-iops.c                         |    2 
 drivers/ieee1394/nodemgr.c                     |   24 ++++++---
 drivers/ieee1394/video1394.c                   |    8 +++
 drivers/input/mouse/psmouse-base.c             |   28 ++++++++++
 drivers/input/mouse/psmouse.h                  |    1 
 drivers/input/mouse/synaptics.c                |    1 
 drivers/kvm/kvm.h                              |    2 
 drivers/macintosh/Kconfig                      |    2 
 drivers/md/bitmap.c                            |   22 +++++++-
 drivers/md/raid10.c                            |   38 +++++++-------
 drivers/md/raid5.c                             |   42 ++++++++++++++-
 drivers/media/dvb/dvb-core/dvbdev.c            |   13 ++++
 drivers/media/dvb/dvb-usb/cxusb.c              |    4 -
 drivers/media/dvb/dvb-usb/digitv.c             |    2 
 drivers/media/video/cx25840/cx25840-core.c     |    4 -
 drivers/media/video/cx25840/cx25840-firmware.c |    2 
 drivers/media/video/cx88/cx88-blackbird.c      |   14 +++--
 drivers/media/video/cx88/cx88.h                |    1 
 drivers/media/video/pvrusb2/pvrusb2-encoder.c  |   40 +++++++++++++++
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |   33 ++++++------
 drivers/mmc/sdhci.c                            |   22 +++++++-
 drivers/mtd/redboot.c                          |   19 +++++--
 drivers/net/forcedeth.c                        |    2 
 drivers/net/sky2.c                             |    6 --
 drivers/net/sky2.h                             |    2 
 drivers/net/tulip/dmfe.c                       |    9 ---
 drivers/net/wireless/bcm43xx/bcm43xx.h         |    2 
 drivers/net/wireless/bcm43xx/bcm43xx_main.c    |   19 +++----
 drivers/net/wireless/bcm43xx/bcm43xx_xmit.h    |   10 ---
 drivers/net/wireless/prism54/isl_ioctl.c       |    8 ++-
 drivers/rtc/rtc-pcf8563.c                      |   40 ++++++++++++---
 drivers/sbus/char/bbc_i2c.c                    |   17 +++---
 drivers/scsi/gdth.c                            |    2 
 drivers/usb/atm/ueagle-atm.c                   |    1 
 drivers/usb/core/hub.c                         |    6 ++
 drivers/usb/host/ehci-hcd.c                    |   16 ++++++
 drivers/usb/host/uhci-hub.c                    |   11 ++--
 drivers/usb/input/hid-core.c                   |    4 -
 drivers/usb/misc/appledisplay.c                |    4 -
 drivers/usb/net/usbnet.c                       |    7 +-
 drivers/video/aty/mach64_ct.c                  |    3 -
 fs/9p/vfs_inode.c                              |    7 --
 fs/binfmt_elf.c                                |    3 -
 fs/buffer.c                                    |    1 
 fs/ext2/super.c                                |    4 +
 fs/ext3/super.c                                |    4 +
 fs/ext4/super.c                                |    4 +
 fs/gfs2/quota.c                                |    2 
 fs/hugetlbfs/inode.c                           |    5 +
 fs/lockd/clntproc.c                            |    9 +--
 fs/lockd/svclock.c                             |    4 -
 fs/ocfs2/journal.h                             |    4 -
 fs/ufs/dir.c                                   |   21 ++++---
 fs/ufs/super.c                                 |    5 +
 include/asm-generic/page.h                     |   38 +-------------
 include/asm-x86_64/bitops.h                    |    2 
 include/linux/atmarp.h                         |    2 
 include/linux/binfmts.h                        |    1 
 include/linux/lockdep.h                        |    2 
 include/linux/pci_ids.h                        |    1 
 include/linux/raid/bitmap.h                    |    1 
 include/linux/sunrpc/svcsock.h                 |    2 
 include/linux/ufs_fs.h                         |    1 
 include/linux/writeback.h                      |    2 
 kernel/lockdep.c                               |    2 
 kernel/power/user.c                            |   19 ++++---
 kernel/sched.c                                 |    4 -
 kernel/time/clocksource.c                      |    1 
 lib/Kconfig.debug                              |    2 
 lib/swiotlb.c                                  |    2 
 mm/hugetlb.c                                   |    2 
 mm/page-writeback.c                            |   13 ++++
 mm/vmscan.c                                    |    2 
 net/atm/common.c                               |    3 -
 net/ipv4/igmp.c                                |    2 
 net/ipv4/netfilter/ipt_REJECT.c                |    4 +
 net/ipv4/tcp.c                                 |   24 ++++-----
 net/ipv4/tcp_output.c                          |    7 +-
 net/ipv4/xfrm4_mode_tunnel.c                   |    1 
 net/ipv6/addrconf.c                            |    2 
 net/ipv6/anycast.c                             |    1 
 net/ipv6/inet6_hashtables.c                    |    2 
 net/ipv6/mcast.c                               |    2 
 net/ipx/af_ipx.c                               |   24 ++++++---
 net/key/af_key.c                               |   11 ++--
 net/netfilter/nfnetlink_log.c                  |   15 ++++-
 net/sunrpc/pmap_clnt.c                         |    8 +--
 net/sunrpc/svc.c                               |   29 +++++-----
 net/sunrpc/svcsock.c                           |   66 +++++++++++++++++++------
 net/xfrm/xfrm_policy.c                         |    7 ++
 net/xfrm/xfrm_user.c                           |   18 +++---
 security/keys/key.c                            |   33 +++++-------
 sound/pci/hda/hda_intel.c                      |    2 
 sound/usb/usbaudio.c                           |   51 ++++++++++++-------
 150 files changed, 976 insertions(+), 403 deletions(-)
