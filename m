Return-Path: <linux-kernel-owner+w=401wt.eu-S1750831AbYJ2Ekr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750831AbYJ2Ekr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 00:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYJ2Eki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 00:40:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:64173 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYJ2Ekg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 00:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sEJf3gCEpbdcryf8cJ62j+XtIDyHhS8eOm8f8K/bjEwG4enmqlDBFr/7yOX0ciwNer
         UmaDANSGv3Wk6kshgHZwFOnbO5WFAHH6EjNMEGqIvxbhAA5UrKXugxdKD1jeN/l6sg8b
         gdwwojEBeUtQedu9JRTNiQvAn1+Px0BnQFpBs=
Date: Wed, 29 Oct 2008 07:43:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: [GIT] headers redux
Message-ID: <20081029044351.GA2304@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/headers.git headers

to liberate linux/interrupt.h from sched.h.

It was cross-compiled pretty extensively against 2.6.28-rc2. Still, fallout
is expected on cris, frv, h8300, m32r, mn10300 and xtensa where it wasn't.

Al, can you please, check those archs after Linus pulls (if he will).

Alexey Dobriyan (2):
	headers: move release_kernel_lock(), reacquire_kernel_lock() to sched.c
	headers: reduction in interrupt.h

 arch/arm/mach-integrator/pci_v3.c               |    1 +
 arch/arm/mach-msm/dma.c                         |    2 +-
 arch/arm/plat-mxc/dma-mx1-mx2.c                 |    1 +
 arch/arm/plat-omap/include/mach/irda.h          |    2 ++
 arch/blackfin/kernel/time.c                     |    1 +
 arch/um/drivers/line.c                          |    1 +
 arch/um/kernel/irq.c                            |    1 +
 arch/x86/kernel/hpet.c                          |    1 +
 arch/x86/kernel/irq_64.c                        |    1 +
 arch/x86/kernel/pci-gart_64.c                   |    1 +
 arch/x86/xen/time.c                             |    1 +
 crypto/aead.c                                   |    1 +
 drivers/char/applicom.c                         |    1 +
 drivers/char/epca.c                             |    1 +
 drivers/char/generic_serial.c                   |    1 +
 drivers/char/istallion.c                        |    1 +
 drivers/char/nozomi.c                           |    1 +
 drivers/char/pty.c                              |    1 +
 drivers/char/rio/riocmd.c                       |    1 +
 drivers/char/rio/rioctrl.c                      |    1 +
 drivers/char/rio/riotty.c                       |    1 +
 drivers/char/ser_a2232.c                        |    1 +
 drivers/char/stallion.c                         |    1 +
 drivers/char/tlclk.c                            |    1 +
 drivers/crypto/hifn_795x.c                      |    3 ++-
 drivers/dma/mv_xor.h                            |    1 +
 drivers/infiniband/core/iwcm.c                  |    1 +
 drivers/infiniband/core/multicast.c             |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c           |    1 +
 drivers/infiniband/hw/ipath/ipath_driver.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c     |    1 +
 drivers/infiniband/hw/ipath/ipath_intr.c        |    1 +
 drivers/infiniband/hw/ipath/ipath_kernel.h      |    2 ++
 drivers/infiniband/hw/ipath/ipath_qp.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_ruc.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_ud.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c  |    1 +
 drivers/infiniband/hw/ipath/ipath_user_sdma.c   |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    2 +-
 drivers/input/keyboard/hilkbd.c                 |    1 +
 drivers/input/keyboard/sunkbd.c                 |    1 +
 drivers/input/serio/libps2.c                    |    1 +
 drivers/input/serio/serport.c                   |    1 +
 drivers/input/touchscreen/ads7846.c             |    1 +
 drivers/isdn/capi/kcapi.c                       |    1 +
 drivers/isdn/hisax/arcofi.c                     |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                 |    1 +
 drivers/isdn/hisax/hfc_2bds0.c                  |    1 +
 drivers/isdn/hisax/hfc_pci.c                    |    1 +
 drivers/isdn/pcbit/drv.c                        |    2 +-
 drivers/isdn/pcbit/layer2.c                     |    2 +-
 drivers/isdn/sc/init.c                          |    1 +
 drivers/lguest/interrupts_and_traps.c           |    1 +
 drivers/message/fusion/mptlan.c                 |    1 +
 drivers/mfd/ucb1x00-core.c                      |    1 +
 drivers/misc/ibmasm/command.c                   |    2 +-
 drivers/misc/ibmasm/event.c                     |    2 +-
 drivers/misc/ibmasm/r_heartbeat.c               |    2 +-
 drivers/misc/sgi-gru/grufile.c                  |    1 +
 drivers/mtd/onenand/omap2.c                     |    1 +
 drivers/net/amd8111e.c                          |    2 +-
 drivers/net/chelsio/cxgb2.c                     |    1 +
 drivers/net/depca.c                             |    1 +
 drivers/net/e100.c                              |    1 +
 drivers/net/e1000e/ich8lan.c                    |    1 +
 drivers/net/eql.c                               |    2 +-
 drivers/net/ewrk3.c                             |    1 +
 drivers/net/hamachi.c                           |    1 +
 drivers/net/hamradio/baycom_epp.c               |    1 +
 drivers/net/hamradio/baycom_ser_fdx.c           |    1 +
 drivers/net/hamradio/baycom_ser_hdx.c           |    1 +
 drivers/net/hamradio/hdlcdrv.c                  |    1 +
 drivers/net/hp100.c                             |    1 +
 drivers/net/igb/igb_ethtool.c                   |    1 +
 drivers/net/irda/sir_dev.c                      |    1 +
 drivers/net/irda/toim3232-sir.c                 |    1 +
 drivers/net/mii.c                               |    2 +-
 drivers/net/ns83820.c                           |    1 +
 drivers/net/pcnet32.c                           |    1 +
 drivers/net/phy/phy.c                           |    1 +
 drivers/net/sb1000.c                            |    1 +
 drivers/net/sis900.c                            |    1 +
 drivers/net/skfp/skfddi.c                       |    1 +
 drivers/net/skge.c                              |    1 +
 drivers/net/slip.c                              |    1 +
 drivers/net/sungem.c                            |    1 +
 drivers/net/tlan.c                              |    1 +
 drivers/net/tokenring/ibmtr.c                   |    1 +
 drivers/net/tulip/tulip_core.c                  |    2 +-
 drivers/net/typhoon.c                           |    1 +
 drivers/net/wan/cycx_x25.c                      |    1 +
 drivers/net/wan/dscc4.c                         |    1 +
 drivers/net/wan/farsync.c                       |    1 +
 drivers/net/wan/pci200syn.c                     |    2 +-
 drivers/net/wan/syncppp.c                       |    1 +
 drivers/net/wireless/b43/main.c                 |    1 +
 drivers/net/wireless/b43/pio.c                  |    2 +-
 drivers/net/wireless/b43legacy/main.c           |    1 +
 drivers/net/wireless/b43legacy/phy.c            |    1 +
 drivers/net/wireless/hostap/hostap_info.c       |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c      |    1 +
 drivers/net/wireless/ipw2200.c                  |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    1 +
 drivers/net/wireless/libertas/cmd.c             |    2 +-
 drivers/net/wireless/libertas/tx.c              |    1 +
 drivers/net/wireless/orinoco.c                  |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c        |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c       |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.c       |    1 +
 drivers/net/yellowfin.c                         |    1 +
 drivers/pci/pcie/aer/aerdrv.c                   |    1 +
 drivers/spi/omap2_mcspi.c                       |    1 +
 drivers/spi/orion_spi.c                         |    1 +
 drivers/usb/gadget/m66592-udc.h                 |    2 ++
 drivers/uwb/whc-rc.c                            |    1 +
 fs/file.c                                       |    1 +
 include/linux/interrupt.h                       |   15 +++++++--------
 include/linux/mmc/host.h                        |    2 +-
 include/linux/serio.h                           |    1 +
 include/linux/smp_lock.h                        |   20 +-------------------
 kernel/hrtimer.c                                |    1 +
 kernel/irq/proc.c                               |    1 +
 kernel/mutex-debug.c                            |    1 +
 kernel/sched.c                                  |   20 ++++++++++++++++++++
 kernel/time/timekeeping.c                       |    1 +
 lib/debugobjects.c                              |    1 +
 lib/fault-inject.c                              |    1 +
 lib/kernel_lock.c                               |    1 +
 mm/vmalloc.c                                    |    1 +
 net/irda/ircomm/ircomm_tty_attach.c             |    1 +
 net/irda/irlan/irlan_common.c                   |    1 +
 net/irda/irlan/irlan_eth.c                      |    1 +
 net/netfilter/nf_conntrack_core.c               |    1 +
 net/sunrpc/xprtrdma/rpc_rdma.c                  |    1 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c        |    1 +
 net/sunrpc/xprtrdma/transport.c                 |    1 +
 net/sunrpc/xprtrdma/verbs.c                     |    1 +
 143 files changed, 172 insertions(+), 50 deletions(-)
