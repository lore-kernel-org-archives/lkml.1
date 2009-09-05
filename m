Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbZIEAdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbZIEAdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbZIEAdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:33:43 -0400
Received: from kroah.org ([198.145.64.141]:42060 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934549AbZIEAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:32 -0400
Date: Fri, 4 Sep 2009 17:18:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/71] 2.6.30.6-stable review
Message-ID: <20090905001824.GA18171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.30.6 release.
There are 71 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Sunday, Sept 6, 21:00:00 UTC.  Anything
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 arch/ia64/kernel/pci-dma.c                |    5 -
 arch/powerpc/platforms/ps3/time.c         |    4 +
 arch/x86/include/asm/kvm_host.h           |    3 +
 arch/x86/include/asm/kvm_x86_emulate.h    |    6 +
 arch/x86/kernel/apic/ipi.c                |    3 +
 arch/x86/kernel/cpu/amd.c                 |    2 +-
 arch/x86/kvm/mmu.c                        |   85 ++++++++++++-----
 arch/x86/kvm/svm.c                        |   31 ++++++-
 arch/x86/kvm/vmx.c                        |   42 +++++++--
 arch/x86/kvm/x86.c                        |   70 +++++++++++++--
 arch/x86/kvm/x86_emulate.c                |   20 ++++
 arch/x86/mm/tlb.c                         |   21 ++--
 drivers/acpi/processor_thermal.c          |    6 +-
 drivers/acpi/processor_throttling.c       |   26 +++---
 drivers/ata/libata-core.c                 |    3 +
 drivers/media/video/gspca/ov534.c         |    4 +-
 drivers/net/ehea/ehea.h                   |    2 +-
 drivers/net/ehea/ehea_main.c              |    3 +
 drivers/net/wireless/ar9170/main.c        |    5 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |   26 +++--
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   12 +++
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 +-
 drivers/platform/x86/wmi.c                |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   98 ++++++++++++++------
 drivers/scsi/mpt2sas/mpt2sas_base.h       |    2 +
 drivers/scsi/mpt2sas/mpt2sas_config.c     |   91 +++++-------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  124 ++++++++++++++++++-------
 drivers/usb/core/hcd.h                    |    4 +
 drivers/usb/core/hub.c                    |   40 +++++---
 drivers/usb/core/hub.h                    |    6 +-
 drivers/usb/host/ehci-au1xxx.c            |    2 +
 drivers/usb/host/ehci-fsl.c               |    2 +
 drivers/usb/host/ehci-hcd.c               |    5 +-
 drivers/usb/host/ehci-ixp4xx.c            |    2 +
 drivers/usb/host/ehci-orion.c             |    2 +
 drivers/usb/host/ehci-pci.c               |    2 +
 drivers/usb/host/ehci-ppc-of.c            |    2 +
 drivers/usb/host/ehci-ps3.c               |    2 +
 drivers/usb/host/ehci-q.c                 |   97 ++++++++++++++-----
 drivers/usb/host/ehci.h                   |    2 +
 drivers/video/xen-fbfront.c               |    8 +-
 fs/buffer.c                               |    7 +-
 fs/exec.c                                 |    4 +-
 fs/hugetlbfs/inode.c                      |   20 +++--
 fs/inode.c                                |   40 +++++---
 fs/ocfs2/aops.c                           |   66 ++++++++++----
 fs/select.c                               |    1 +
 fs/xfs/xfs_iget.c                         |  142 +++++++++++++++--------------
 fs/xfs/xfs_inode.h                        |   17 ----
 fs/xfs/xfs_log.c                          |    2 +-
 include/acpi/processor.h                  |    5 +-
 include/linux/bitmap.h                    |   18 ++--
 include/linux/cpumask.h                   |   20 ++--
 include/linux/fs.h                        |    5 +-
 include/linux/hugetlb.h                   |    6 +-
 include/linux/kvm_host.h                  |    1 +
 init/main.c                               |    7 +-
 ipc/shm.c                                 |    8 +-
 kernel/fork.c                             |   20 +---
 kernel/kthread.c                          |    2 +-
 kernel/signal.c                           |   15 ++--
 lib/bitmap.c                              |   12 ++-
 mm/page_alloc.c                           |    4 +-
 net/appletalk/ddp.c                       |    1 +
 net/can/raw.c                             |    1 +
 net/econet/af_econet.c                    |    1 +
 net/ipv4/ip_output.c                      |    2 +
 net/ipv6/af_inet6.c                       |    4 +-
 net/irda/af_irda.c                        |    1 +
 net/llc/af_llc.c                          |    1 +
 net/mac80211/agg-tx.c                     |    8 ++
 net/netrom/af_netrom.c                    |    1 +
 net/rose/af_rose.c                        |    1 +
 net/sunrpc/clnt.c                         |    1 +
 security/integrity/ima/ima_crypto.c       |    6 +-
 sound/core/pcm_lib.c                      |   39 ++------
 sound/pci/hda/patch_realtek.c             |   34 ++++---
 virt/kvm/irq_comm.c                       |    4 +-
 virt/kvm/kvm_main.c                       |    4 +
 80 files changed, 896 insertions(+), 521 deletions(-)
