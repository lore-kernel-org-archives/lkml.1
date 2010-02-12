Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0BLOwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:52:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51582 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0BLOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:52:15 -0500
Date: Fri, 12 Feb 2010 14:51:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, David Howells <dhowells@redhat.com>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 -mm 01/14] adds include/linux/pci-dma.h
Message-ID: <20100212145133.GB18595@n2100.arm.linux.org.uk>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:34:34AM +0900, FUJITA Tomonori wrote:
> This patch adds include/linux/pci-dma.h that defines the pci_unmap
> state API:
> 
> DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
> DECLARE_PCI_UNMAP_LEN(LEN_NAME)
> pci_unmap_addr(PTR, ADDR_NAME)
> pci_unmap_addr_set(PTR, ADDR_NAME, VAL)
> pci_unmap_len(PTR, LEN_NAME)
> pci_unmap_len_set(PTR, LEN_NAME, VAL)
> 
> This enables us to remove lots of the duplication in architecture
> implementations since there are only two ways to define the API.
> 
> If architectures define CONFIG_NEED_DMA_MAP_STATE, they get the real
> definition of pci_unmap state API. If not, they get the noop
> definition.
> 
> In the long term, it's better to replace the API with the generic
> device model API such as DECLARE_DMA_UNMAP_ADDR. We can map the API to
> the generic one (like dma-mapping-compat.h does). This patch also
> makes the migration process easier. We can remove this file after the
> migration.
> 
> It might be simpler to add the API to include/linux/pci.h but looks
> it's already too large. We'll remove pci-dma.h after finishing moving
> to the generic device model. So I put the API to a separate file.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
