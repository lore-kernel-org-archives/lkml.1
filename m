Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0BIOQ5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:16:57 -0500
Received: from sh.osrg.net ([192.16.179.4]:49158 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab0BIOQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:16:54 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH -mm 00/12] adds include/asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:12 +0900
Message-Id: <1265722524-9493-1-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds include/asm-generic/pci-dma-common.h that defines
the pci_unmap state API:

DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
DECLARE_PCI_UNMAP_LEN(LEN_NAME)
pci_unmap_addr(PTR, ADDR_NAME)
pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
pci_unmap_len(PTR, LEN_NAME)
pci_unmap_len_set(PTR, LEN_NAME, VAL)

This enables us to remove lots of the duplication in architecture
implementations since there are only two ways to define the API.

If architectures define HAVE_ARCH_PCI_UNMAP, they get the real
definition of pci_unmap state API. If not, they get the noop
definition.

In the long term, it's better to replace the API with the generic
device model API such as DECLARE_DMA_UNMAP_ADDR. We can map the API to
the generic one (like dma-mapping-compat.h does). This patch also
makes the migration process easier.

=
 arch/alpha/include/asm/pci.h         |   14 ++------------
 arch/arm/include/asm/pci.h           |    8 ++------
 arch/frv/include/asm/pci.h           |    7 +------
 arch/ia64/include/asm/pci.h          |   14 ++------------
 arch/mips/include/asm/pci.h          |   23 +++--------------------
 arch/parisc/include/asm/pci.h        |   14 ++------------
 arch/powerpc/include/asm/pci.h       |   33 +++------------------------------
 arch/sh/include/asm/pci.h            |   15 ++-------------
 arch/sparc/include/asm/pci.h         |    3 +++
 arch/sparc/include/asm/pci_32.h      |   14 --------------
 arch/sparc/include/asm/pci_64.h      |   14 --------------
 arch/x86/include/asm/pci.h           |   27 ++-------------------------
 arch/xtensa/include/asm/pci.h        |    7 +------
 include/asm-generic/pci-dma-common.h |   20 ++++++++++++++++++++
 14 files changed, 43 insertions(+), 170 deletions(-)



