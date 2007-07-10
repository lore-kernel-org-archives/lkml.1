Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXGJPUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXGJPUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXGJPUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:20:35 -0400
Received: from xenotime.net ([66.160.160.81]:44249 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754245AbXGJPUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:20:34 -0400
Date: Tue, 10 Jul 2007 08:24:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH][Doc] Document pci_iomap()
Message-Id: <20070710082410.352042e1.rdunlap@xenotime.net>
In-Reply-To: <200707101111.29194.eike-kernel@sf-tec.de>
References: <200707081754.03824.eike-kernel@sf-tec.de>
	<200707081809.20312.eike-kernel@sf-tec.de>
	<20070709085841.179a8c33.rdunlap@xenotime.net>
	<200707101111.29194.eike-kernel@sf-tec.de>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:11:28 +0200 Rolf Eike Beer wrote:

> This useful interface is hardly mentioned anywhere in the in-tree
> documentation.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> commit bdf4a23b9b1ff4be79a6f9b863f7203dba2dc808
> tree a53c4a6c90e13d55fbf2a0b40cd9676bd9a5d0e5
> parent 33738cbb6555861de1dce626c913fad06ce658cc
> author Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 10 Jul 2007 11:08:51 +0200
> committer Rolf Eike Beer <eike-kernel@sf-tec.de> Tue, 10 Jul 2007 11:08:51 +0200
> 
>  Documentation/DocBook/deviceiobook.tmpl |    3 ++-
>  include/asm-i386/io.h                   |    3 +++
>  lib/iomap.c                             |   15 ++++++++++++++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/deviceiobook.tmpl b/Documentation/DocBook/deviceiobook.tmpl
> index 90ed23d..c917de6 100644
> --- a/Documentation/DocBook/deviceiobook.tmpl
> +++ b/Documentation/DocBook/deviceiobook.tmpl
> @@ -316,7 +316,8 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_lock, flags)
>  
>    <chapter id="pubfunctions">
>       <title>Public Functions Provided</title>
> -!Einclude/asm-i386/io.h
> +!Iinclude/asm-i386/io.h
> +!Elib/iomap.c
>    </chapter>
>  
>  </book>
> diff --git a/include/asm-i386/io.h b/include/asm-i386/io.h
> index e797586..c48ef18 100644
> --- a/include/asm-i386/io.h
> +++ b/include/asm-i386/io.h
> @@ -112,6 +112,9 @@ extern void __iomem * __ioremap(unsigned long offset, unsigned long size, unsign
>   * writew/writel functions and the other mmio helpers. The returned
>   * address is not guaranteed to be usable directly as a virtual
>   * address. 
> + *
> + * If the area you are trying to map is a PCI BAR you should have a
> + * look at pci_iomap().
>   */
>  
>  static inline void __iomem * ioremap(unsigned long offset, unsigned long size)
> diff --git a/lib/iomap.c b/lib/iomap.c
> index a57d262..864f2ec 100644
> --- a/lib/iomap.c
> +++ b/lib/iomap.c
> @@ -240,7 +240,20 @@ void ioport_unmap(void __iomem *addr)
>  EXPORT_SYMBOL(ioport_map);
>  EXPORT_SYMBOL(ioport_unmap);
>  
> -/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
> +/**
> + * pci_iomap - create a virtual mapping cookie for a PCI BAR
> + * @dev: PCI device that owns the BAR
> + * @bar: BAR number
> + * @maxlen: length of the memory to map
> + *
> + * Using this function you will get a __iomem address to your device BAR.
> + * You can access it using ioread*() and iowrite*(). These functions hide
> + * the details if this is a MMIO or PIO address space and will just do what
> + * you expect from them in the correct way.
> + *
> + * @maxlen specifies the maximum length to map. If you want to get access to
> + * the complete BAR without checking for its length first, pass %0 here.
> + * */
>  void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>  {
>  	unsigned long start = pci_resource_start(dev, bar);
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
