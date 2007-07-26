Return-Path: <linux-kernel-owner+w=401wt.eu-S936382AbXGZSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936382AbXGZSlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934438AbXGZSlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:41:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:24707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017AbXGZSlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:41:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="271003214"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [GIT PATCH] I/OAT: Add support for DCA - Direct Cache Access
Date: Thu, 26 Jul 2007 11:41:07 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02C1F61B@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PATCH] I/OAT: Add support for DCA - Direct Cache Access
Thread-Index: AcfPsyvgnpzjRxAsTYagjGLjEgssvgAAIsvQ
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Jul 2007 18:41:07.0792 (UTC) FILETIME=[8782FD00:01C7CFB4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

In order to include support for DCA (Direct Cache Access) from IOAT,
please pull from my git tree at
	git://lost.foo-projects.org/~sln/linux-2.6 dma-upstream

This will update the drivers as shown below.

These were orignially posted and Ack'd last week.
http://marc.info/?l=linux-kernel&m=118489237427303&w=2

Thanks,
Sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.



 b/drivers/Kconfig                 |    2 
 b/drivers/Makefile                |    1 
 b/drivers/dca/Kconfig             |   11 
 b/drivers/dca/Makefile            |    2 
 b/drivers/dca/dca-core.c          |  170 +++++
 b/drivers/dca/dca-sysfs.c         |   88 ++
 b/drivers/dma/Makefile            |    2 
 b/drivers/dma/ioat.c              |  198 ++++++
 b/drivers/dma/ioat_dca.c          |  259 ++++++++
 b/drivers/dma/ioat_dma.c          | 1182
+++++++++++++++++++++++++++++++++++---
 b/drivers/dma/ioatdma.c           |    5 
 b/drivers/dma/ioatdma.h           |    2 
 b/drivers/dma/ioatdma_hw.h        |    2 
 b/drivers/dma/ioatdma_registers.h |    6 
 b/include/linux/dca.h             |   47 +
 b/include/linux/pci_ids.h         |    2 
 drivers/dma/Makefile              |    3 
 drivers/dma/ioat_dma.c            |  396 +++++-------
 drivers/dma/ioatdma.c             |  829 --------------------------
 drivers/dma/ioatdma.h             |   28 
 20 files changed, 2090 insertions(+), 1145 deletions(-)


commit 883adb50f64b32e2ae1b414170a4e2bf10907df2
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:06 2007 -0700

    I/OAT: Add DCA services
    
    Add code to connect to the DCA driver and provide cpu tags for use
by
    drivers that would like to use Direct Cache Access hints.
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 cec0c9c... b152cd8... M	drivers/dma/Makefile
:100644 100644 9d9f672... 8ae8c53... M	drivers/dma/ioat.c
:000000 100644 0000000... c3a500b... A	drivers/dma/ioat_dca.c
:100644 100644 2b499d5... bab2a72... M	drivers/dma/ioatdma.h

commit b392c8243d64d2db1aced9c1718826036dbc87ec
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:05 2007 -0700

    DCA: Add Direct Cache Access driver
    
    Direct Cache Access (DCA) is a method for warming the CPU cache
before data
    is used, with the intent of lessening the impact of cache misses.
This
    patch adds a manager and interface for matching up client requests
for DCA
    services with devices that offer DCA services.
    
    In order to use DCA, a module must do bus writes with the
appropriate tag
    bits set to trigger a cache read for a specific CPU.  However,
different
    CPUs and chipsets can require different sets of tag bits, and the
methods
    for determining the correct bits may be simple hardcoding or may be
a
    hardware specific magic incantation.  This interface is a way for
DCA
    clients to find the correct tag bits for the targeted CPU without
needing
    to know the specifics.
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 3e1c442... b447e60... M	drivers/Kconfig
:100644 100644 a9e4c5f... 1b96d51... M	drivers/Makefile
:000000 100644 0000000... d901615... A	drivers/dca/Kconfig
:000000 100644 0000000... b2db56b... A	drivers/dca/Makefile
:000000 100644 0000000... 864f469... A	drivers/dca/dca-core.c
:000000 100644 0000000... 24a263b... A	drivers/dca/dca-sysfs.c
:000000 100644 0000000... 83eaecc... A	include/linux/dca.h

commit 0d56caad5ff80c3ad179b7066ad5fecc53a1c852
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:03 2007 -0700

    I/OAT: Add support for MSI and MSI-X
    
    Add support for MSI and MSI-X interrupt handling, including the
ability
    to choose the desired interrupt method.
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 62bea23... 55f4179... M	drivers/dma/ioat_dma.c
:100644 100644 87c5e00... 2b499d5... M	drivers/dma/ioatdma.h
:100644 100644 a30c734... baaab5e... M	drivers/dma/ioatdma_registers.h

commit e3bc963e3223512a7c21cf6cda83670d8c2b3b32
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:02 2007 -0700

    I/OAT: Split PCI startup from DMA handling code
    
    Split the general PCI startup from the DMA handling code in order to
    prepare for adding support for DCA services and future versions of
the
    ioatdma device.
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 77bee99... cec0c9c... M	drivers/dma/Makefile
:000000 100644 0000000... 9d9f672... A	drivers/dma/ioat.c
:100644 100644 0a56361... 62bea23... M	drivers/dma/ioat_dma.c
:100644 100644 d372647... 87c5e00... M	drivers/dma/ioatdma.h
:100644 100644 4d7a128... 9e7434e... M	drivers/dma/ioatdma_hw.h

commit c601d0f07db1af73a1d1daad32d5a07a2abd357f
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:01 2007 -0700

    I/OAT: code cleanup from checkpatch output
    
    Take care of a bunch of little code nits in ioatdma files
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 52e2ac2... 0a56361... M	drivers/dma/ioat_dma.c

commit 179f8eb9183dcf9b9c32970e50442fee750b4e4c
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:27:00 2007 -0700

    I/OAT: Rename the source file
    
    Rename the ioatdma.c file in preparation for splitting into multiple
files,
    which will allow for easier adding new functionality.
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 b3839b6... 77bee99... M	drivers/dma/Makefile
:000000 100644 0000000... 52e2ac2... A	drivers/dma/ioat_dma.c
:100644 000000 52e2ac2... 0000000... D	drivers/dma/ioatdma.c

commit 10ad6f8f1358b0a2a169b8554dc4cf5335aeb332
Author: Shannon Nelson <shannon.nelson@intel.com>
Date:   Thu Jul 26 11:26:59 2007 -0700

    I/OAT: New device ids
    
    Add device ids for new revs of the Intel I/OAT DMA engine
    
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: David S. Miller <davem@davemloft.net>

:100644 100644 5fbe56b... 52e2ac2... M	drivers/dma/ioatdma.c
:100644 100644 dc41ad4... e071ec4... M	include/linux/pci_ids.h
