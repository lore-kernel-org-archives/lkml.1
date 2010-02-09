Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0BIP1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:27:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab0BIP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:27:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: e@lab.ntt.co.jp
Subject: Re: [PATCH -mm 00/12] adds include/asm-generic/pci-dma-common.h
Date: Tue, 9 Feb 2010 16:23:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, James Bottomley <James.Bottomley@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Zankel <chris@zankel.net>
References: <1265722524-9493-1-git-send-email-e>
In-Reply-To: <1265722524-9493-1-git-send-email-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201002091623.35791.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197OtuFvqgEfsXAJGL3FXZ2F092u2RvGn44SM9
 qFJVRgZ3g+vW0ZlrxdZ8YqcXg+8VRk7/rZ0Lc4xC2CrCnOiMcs
 2NwZQcIOPVVtJ9Biu9c9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 February 2010, e@lab.ntt.co.jp wrote:
> This patchset adds include/asm-generic/pci-dma-common.h that defines
> the pci_unmap state API:
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

Good stuff, moving this code to a common location is certainly
a step in the right direction.

A few general comments though:

* It seems you left out arch/cris for no good reason.
* The general tendency nowadays is to avoid new HAVE_ARCH_*
  macros and instead using either a Kconfig symbol or
  checking the presence of the macros themselves. In this case,
  the macro would always be present, so CONFIG_PCI_UNMAP
  would be reasonable.
* AFAICT, there are no architectures left doing the
  non-generic version, so the code could be moved to
  a global file in include/linux instead of include/asm-generic.
  While include/linux/pci.h is already a bit overloaded, it's
  probably the right place for this. Alternatively,
  include/linux/pci-dma.h, included from include/linux/pci.h.

> In the long term, it's better to replace the API with the generic
> device model API such as DECLARE_DMA_UNMAP_ADDR. We can map the API to
> the generic one (like dma-mapping-compat.h does). This patch also
> makes the migration process easier.

Agreed.
 
	Arnd
