Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbZFIJuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbZFIJuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZFIJuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:50:10 -0400
Received: from kroah.org ([198.145.64.141]:37479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZFIJuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:50:08 -0400
Date: Tue, 9 Jun 2009 02:44:51 -0700
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
Subject: [patch 00/87] 2.6.29-stable review
Message-ID: <20090609094451.GA26439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.29.5 release.
There are 87 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by June 11 09:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.29.5-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/ext4.txt     |    5 +-
 Makefile                               |    2 +-
 arch/powerpc/mm/tlb_nohash_low.S       |    2 +-
 arch/sparc/kernel/of_device_32.c       |   21 ++++++-
 arch/sparc/kernel/of_device_64.c       |   21 ++++++-
 arch/sparc/kernel/smp_64.c             |    4 +-
 arch/x86/kernel/hpet.c                 |   41 +++++++++---
 arch/x86/kvm/mmu.c                     |    3 +-
 arch/x86/kvm/x86.c                     |    6 ++-
 arch/x86/mm/hugetlbpage.c              |    6 ++-
 arch/x86/pci/mmconfig-shared.c         |    6 +-
 crypto/api.c                           |    3 +-
 drivers/acpi/processor_idle.c          |    8 ++-
 drivers/block/xen-blkfront.c           |    6 +-
 drivers/char/random.c                  |   19 ++++--
 drivers/char/tpm/tpm_bios.c            |    3 +-
 drivers/crypto/padlock-aes.c           |    2 +-
 drivers/gpu/drm/r128/r128_cce.c        |    6 +-
 drivers/hid/usbhid/hid-core.c          |    2 +-
 drivers/hwmon/lm78.c                   |    2 +-
 drivers/ide/ide-io.c                   |    4 +-
 drivers/ide/ide-iops.c                 |   21 +++++-
 drivers/ide/ide-pci-generic.c          |   11 +++
 drivers/ide/ide-tape.c                 |    6 --
 drivers/mtd/devices/mtd_dataflash.c    |    2 +-
 drivers/net/Makefile                   |    2 +-
 drivers/net/bnx2.c                     |    2 +
 drivers/net/bonding/bond_alb.c         |   10 +---
 drivers/net/e1000/e1000_main.c         |    5 +-
 drivers/net/igb/igb_ethtool.c          |    4 +
 drivers/net/mac8390.c                  |   10 ++--
 drivers/net/macvlan.c                  |    9 ++-
 drivers/net/myri10ge/myri10ge.c        |    1 +
 drivers/net/r8169.c                    |  102 +++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++---
 drivers/scsi/3w-xxxx.c                 |    5 +-
 drivers/scsi/3w-xxxx.h                 |    2 +-
 drivers/serial/icom.c                  |    2 +-
 drivers/serial/mpc52xx_uart.c          |    2 +-
 drivers/usb/class/cdc-acm.c            |    4 -
 drivers/usb/host/isp1760-hcd.c         |   24 +++++++-
 drivers/usb/serial/ftdi_sio.c          |    9 +---
 drivers/usb/serial/usb-serial.c        |    1 +
 fs/ext4/ext4.h                         |   30 +++++++++-
 fs/ext4/extents.c                      |   19 ++++--
 fs/ext4/file.c                         |    7 ++-
 fs/ext4/ialloc.c                       |   17 ++---
 fs/ext4/inode.c                        |  106 ++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c                        |   17 +++++-
 fs/ext4/namei.c                        |   18 +++++-
 fs/ext4/super.c                        |   25 ++++----
 fs/jbd2/revoke.c                       |   24 ++++++--
 fs/nfs/dir.c                           |    3 +-
 include/linux/ptrace.h                 |    1 +
 kernel/exit.c                          |   83 ++++++++++++-------------
 kernel/futex.c                         |   24 ++++---
 kernel/ptrace.c                        |   25 ++++----
 mm/hugetlb.c                           |   26 ++++----
 mm/slub.c                              |    3 +
 net/8021q/vlan_dev.c                   |    3 +-
 net/core/pktgen.c                      |    2 +-
 net/core/skbuff.c                      |    2 +-
 net/ipv4/route.c                       |   60 ++++++------------
 net/ipv4/tcp.c                         |    5 +-
 net/ipv4/tcp_input.c                   |    3 +
 net/mac80211/rc80211_minstrel.c        |    4 +-
 net/mac80211/rc80211_pid_algo.c        |   73 ++++++++++++----------
 net/rose/af_rose.c                     |   10 ---
 net/sched/sch_teql.c                   |    5 +-
 net/wimax/op-msg.c                     |   11 ++--
 net/wireless/reg.c                     |    7 ++
 net/xfrm/xfrm_state.c                  |    6 +-
 security/keys/request_key.c            |    9 ++-
 security/selinux/hooks.c               |    2 +-
 sound/pci/hda/patch_realtek.c          |    1 +
 sound/usb/usbaudio.c                   |    2 +-
 sound/usb/usbaudio.h                   |    2 +-
 sound/usb/usbmidi.c                    |   12 +++-
 sound/usb/usbquirks.h                  |    2 +-
 virt/kvm/kvm_main.c                    |    1 +
 80 files changed, 692 insertions(+), 385 deletions(-)
