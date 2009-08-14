Return-Path: <linux-kernel-owner+w=401wt.eu-S932599AbZHNPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbZHNPnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbZHNPnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:43:05 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55779 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZHNPnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:43:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 0/6] AlacrityVM guest drivers
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 14 Aug 2009 11:42:52 -0400
Message-ID: <20090814154125.26116.70709.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to v2.6.31-rc6)

This series implements the guest-side drivers for accelerated IO
when running on top of the AlacrityVM hypervisor, the details of
which you can find here:

http://developer.novell.com/wiki/index.php/AlacrityVM

This series includes the basic plumbing, as well as the driver for
accelerated 802.x (ethernet) networking.

[ Changelog:

  v3:
     *) pci-bridge changes:
          *) updated ABI to support FASTCALL
          *) got rid of confusing "hypercall" nomenclature

  v2:
     *) venet changes: Updated venet driver based on Stephen Hemminger's
        feedback
	  *) folded patches 6/7 and 7/7 together
	  *) get rid of shadow flags
	  *) add missing baseline .ndo callbacks
	  *) add support for ethtool

  v1:
     *) initial release
}

Regards,
-Greg

---

Gregory Haskins (6):
      net: Add vbus_enet driver
      ioq: add driver-side vbus helpers
      vbus-proxy: add a pci-to-vbus bridge
      vbus: add a "vbus-proxy" bus model for vbus_driver objects
      ioq: Add basic definitions for a shared-memory, lockless queue
      shm-signal: shared-memory signals


 MAINTAINERS                 |   25 +
 arch/x86/Kconfig            |    2 
 drivers/Makefile            |    1 
 drivers/net/Kconfig         |   14 +
 drivers/net/Makefile        |    1 
 drivers/net/vbus-enet.c     |  895 +++++++++++++++++++++++++++++++++++++++++++
 drivers/vbus/Kconfig        |   24 +
 drivers/vbus/Makefile       |    6 
 drivers/vbus/bus-proxy.c    |  216 ++++++++++
 drivers/vbus/pci-bridge.c   |  877 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild        |    4 
 include/linux/ioq.h         |  415 ++++++++++++++++++++
 include/linux/shm_signal.h  |  189 +++++++++
 include/linux/vbus_driver.h |   80 ++++
 include/linux/vbus_pci.h    |  145 +++++++
 include/linux/venet.h       |   84 ++++
 lib/Kconfig                 |   21 +
 lib/Makefile                |    2 
 lib/ioq.c                   |  294 ++++++++++++++
 lib/shm_signal.c            |  192 +++++++++
 20 files changed, 3487 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/vbus-enet.c
 create mode 100644 drivers/vbus/Kconfig
 create mode 100644 drivers/vbus/Makefile
 create mode 100644 drivers/vbus/bus-proxy.c
 create mode 100644 drivers/vbus/pci-bridge.c
 create mode 100644 include/linux/ioq.h
 create mode 100644 include/linux/shm_signal.h
 create mode 100644 include/linux/vbus_driver.h
 create mode 100644 include/linux/vbus_pci.h
 create mode 100644 include/linux/venet.h
 create mode 100644 lib/ioq.c
 create mode 100644 lib/shm_signal.c

-- 
Signature
