Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0BJBkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:40:42 -0500
Received: from sh.osrg.net ([192.16.179.4]:54843 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0BJBki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:40:38 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 -mm 00/14] adds include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:33 +0900
Message-Id: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds include/linux/pci-dma.h that defines the pci_unmap
state API to remove the duplication in architecture implementations:

DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
DECLARE_PCI_UNMAP_LEN(LEN_NAME)
pci_unmap_addr(PTR, ADDR_NAME)
pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
pci_unmap_len(PTR, LEN_NAME)
pci_unmap_len_set(PTR, LEN_NAME, VAL)

This enables us to remove lots of the duplication in architecture
implementations since there are only two ways to define the API.

If architectures define CONFIG_NEED_DMA_MAP_STATE, they get the real
definition of pci_unmap state API. If not, they get the noop
definition.

In the long term, it's better to replace the API with the generic
device model API such as DECLARE_DMA_UNMAP_ADDR. We can map the API to
the generic one (like dma-mapping-compat.h does). This patch also
makes the migration process easier. We can remove this file after the
migration.

It might be simpler to add the API to include/linux/pci.h but looks
it's already too large. We'll remove pci-dma.h after finishing moving
to the generic device model. So I put the API to a separate file.

This is the second version of:

http://marc.info/?l=linux-kernel&m=126572502029999&w=2

=
 arch/alpha/Kconfig              |    3 +++
 arch/alpha/include/asm/pci.h    |   14 --------------
 arch/arm/Kconfig                |    3 +++
 arch/arm/include/asm/pci.h      |   11 -----------
 arch/cris/include/asm/pci.h     |    8 --------
 arch/frv/include/asm/pci.h      |    8 --------
 arch/ia64/Kconfig               |    3 +++
 arch/ia64/include/asm/pci.h     |   14 --------------
 arch/mips/Kconfig               |    4 ++--
 arch/mips/include/asm/pci.h     |   22 ----------------------
 arch/parisc/Kconfig             |    3 +++
 arch/parisc/include/asm/pci.h   |   14 --------------
 arch/powerpc/Kconfig            |    3 +++
 arch/powerpc/include/asm/pci.h  |   32 --------------------------------
 arch/sh/Kconfig                 |    3 +++
 arch/sh/include/asm/pci.h       |   19 -------------------
 arch/sparc/Kconfig              |    3 +++
 arch/sparc/include/asm/pci_32.h |   14 --------------
 arch/sparc/include/asm/pci_64.h |   14 --------------
 arch/x86/Kconfig                |    3 +++
 arch/x86/include/asm/pci.h      |   28 ----------------------------
 arch/xtensa/include/asm/pci.h   |    8 --------
 include/linux/pci-dma.h         |   20 ++++++++++++++++++++
 include/linux/pci.h             |    1 +
 24 files changed, 47 insertions(+), 208 deletions(-)



