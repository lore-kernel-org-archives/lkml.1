Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0BLPKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:10:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab0BLPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:10:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 -mm 01/14] adds include/linux/pci-dma.h
Date: Fri, 12 Feb 2010 15:04:41 +0000
Message-ID: <2892.1265987081@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

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

Acked-by: David Howells <dhowells@redhat.com>
