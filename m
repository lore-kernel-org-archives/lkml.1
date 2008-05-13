Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYEMPlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYEMPlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYEMPlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:41:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61959 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbYEMPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:41:30 -0400
Date: Tue, 13 May 2008 08:39:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com
Subject: Re: [PATCH 1/2] add the device argument to dma_mapping_error
Message-Id: <20080513083901.2f571418.randy.dunlap@oracle.com>
In-Reply-To: <1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1210658692-960-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 15:04:51 +0900 FUJITA Tomonori wrote:

> dma_mapping_error doesn't take a pointer to the device unlike other
> DMA operations. So we can't have dma_mapping_ops per device.
> 
> Note that POWER already has dma_mapping_ops per device but all the
> POWER IOMMUs use the same dma_mapping_error function. x86 IOMMUs use
> different dma_mapping_error functions. So dma_mapping_error needs the
> device argument.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/arm/common/dmabounce.c                    |    2 +-
>  arch/ia64/hp/common/hwsw_iommu.c               |    5 ++-
>  arch/ia64/hp/common/sba_iommu.c                |    2 +-
>  arch/ia64/sn/pci/pci_dma.c                     |    2 +-
>  arch/mips/mm/dma-default.c                     |    2 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
>  arch/powerpc/platforms/cell/spider-pci.c       |    2 +-
>  arch/powerpc/platforms/iseries/mf.c            |    2 +-
>  arch/x86/kernel/pci-gart_64.c                  |    1 -
>  arch/x86/kernel/pci-nommu.c                    |    2 +-
>  drivers/firewire/fw-iso.c                      |    2 +-
>  drivers/firewire/fw-ohci.c                     |    2 +-
>  drivers/firewire/fw-sbp2.c                     |    8 +++---
>  drivers/infiniband/hw/ipath/ipath_sdma.c       |    2 +-
>  drivers/infiniband/hw/ipath/ipath_user_sdma.c  |    6 ++--
>  drivers/infiniband/hw/mthca/mthca_eq.c         |    2 +-
>  drivers/media/dvb/pluto2/pluto2.c              |    2 +-
>  drivers/net/arm/ep93xx_eth.c                   |    4 +-
>  drivers/net/b44.c                              |   22 +++++++++-------
>  drivers/net/bnx2x.c                            |    2 +-
>  drivers/net/e100.c                             |    2 +-
>  drivers/net/e1000e/ethtool.c                   |    4 +-
>  drivers/net/e1000e/netdev.c                    |   11 ++++---
>  drivers/net/ibmveth.c                          |   32 ++++++++++++-----------
>  drivers/net/iseries_veth.c                     |    4 +-
>  drivers/net/mlx4/eq.c                          |    2 +-
>  drivers/net/pasemi_mac.c                       |    6 ++--
>  drivers/net/qla3xxx.c                          |   12 ++++----
>  drivers/net/sfc/rx.c                           |    4 +-
>  drivers/net/sfc/tx.c                           |    2 +-
>  drivers/net/spider_net.c                       |    4 +-
>  drivers/net/tc35815.c                          |    4 +-
>  drivers/net/wireless/ath5k/base.c              |    4 +-
>  drivers/net/wireless/b43/dma.c                 |    2 +-
>  drivers/net/wireless/b43legacy/dma.c           |    2 +-
>  drivers/scsi/ibmvscsi/ibmvscsi.c               |    4 +-
>  drivers/scsi/ibmvscsi/ibmvstgt.c               |    2 +-
>  drivers/scsi/ibmvscsi/rpa_vscsi.c              |    2 +-
>  drivers/spi/atmel_spi.c                        |    4 +-
>  drivers/spi/au1550_spi.c                       |    6 ++--
>  drivers/spi/omap2_mcspi.c                      |    4 +-
>  drivers/spi/pxa2xx_spi.c                       |    4 +-
>  drivers/spi/spi_imx.c                          |    6 ++--
>  include/asm-alpha/dma-mapping.h                |    6 ++--
>  include/asm-alpha/pci.h                        |    2 +-
>  include/asm-arm/dma-mapping.h                  |    2 +-
>  include/asm-avr32/dma-mapping.h                |    2 +-
>  include/asm-cris/dma-mapping.h                 |    2 +-
>  include/asm-frv/dma-mapping.h                  |    2 +-
>  include/asm-generic/dma-mapping-broken.h       |    2 +-
>  include/asm-generic/dma-mapping.h              |    4 +-
>  include/asm-generic/pci-dma-compat.h           |    4 +-
>  include/asm-ia64/machvec.h                     |    2 +-
>  include/asm-m68k/dma-mapping.h                 |    2 +-
>  include/asm-mips/dma-mapping.h                 |    2 +-
>  include/asm-mn10300/dma-mapping.h              |    2 +-
>  include/asm-parisc/dma-mapping.h               |    2 +-
>  include/asm-powerpc/dma-mapping.h              |    2 +-
>  include/asm-sh/dma-mapping.h                   |    2 +-
>  include/asm-sparc/pci.h                        |    3 +-
>  include/asm-sparc64/dma-mapping.h              |    2 +-
>  include/asm-sparc64/pci.h                      |    5 ++-
>  include/asm-v850/pci.h                         |    2 +-
>  include/asm-x86/dma-mapping.h                  |    7 +++--
>  include/asm-x86/swiotlb.h                      |    2 +-
>  include/asm-xtensa/dma-mapping.h               |    2 +-
>  include/linux/i2o.h                            |    2 +-
>  include/rdma/ib_verbs.h                        |    2 +-
>  lib/swiotlb.c                                  |    4 +-
>  69 files changed, 140 insertions(+), 132 deletions(-)

Seems to be missing updates to Documentation/DMA-API.txt ??

---
~Randy
