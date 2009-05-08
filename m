Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZEHLLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZEHLLC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZEHLKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:10:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbZEHLKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:10:49 -0400
Date: Fri, 8 May 2009 13:10:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
Message-ID: <20090508111024.GD11596@elte.hu>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Cc:-ed PCI folks. Original thread with patches is on lkml. There's
  a few details that affect non-Xen PCI code too - and it would be
  nice to see feedback on this general method as well, from the PCI 
  experts . )

* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This branch allows a Xen dom0 kernel to access PCI devices 
> properly.  Mostly this involves making sure that memory being used 
> for DMA is both logically contigious in the kernel's 
> pseudo-physical memory and physically contigious in machine 
> memory.
> 
> Again, this is pretty much unchanged from the last time I posted it.
> 
> The following changes since commit 0c96e43850feb7c7c4a4950f24533491fbd63b5a:
>   Jeremy Fitzhardinge (1):
>         xen: checkpatch cleanups
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/dom0/pci
> 
> Alex Nixon (7):
>       xen: Don't disable the I/O space
>       xen: Allow unprivileged Xen domains to create iomap pages
>       Xen: Rename the balloon lock
>       xen: Add xen_create_contiguous_region
>       x86/PCI: Clean up pci_cache_line_size
>       x86/PCI: Enable scanning of all pci functions
>       Xen/x86/PCI: Add support for the Xen PCI subsytem
> 
> Jeremy Fitzhardinge (4):
>       xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
>       x86/pci: make sure _PAGE_IOMAP it set on pci mappings
>       xen/pci: clean up Kconfig a bit
>       xen: checkpatch cleanups
> 
>  arch/x86/Kconfig                 |    4 +
>  arch/x86/include/asm/io.h        |    2 +
>  arch/x86/include/asm/pci.h       |    8 +-
>  arch/x86/include/asm/pci_x86.h   |    2 +
>  arch/x86/include/asm/xen/iommu.h |   12 ++
>  arch/x86/kernel/pci-dma.c        |    3 +
>  arch/x86/pci/Makefile            |    1 +
>  arch/x86/pci/common.c            |   18 ++-
>  arch/x86/pci/i386.c              |    3 +
>  arch/x86/pci/init.c              |    6 +
>  arch/x86/pci/xen.c               |   51 +++++++
>  arch/x86/xen/Kconfig             |    2 +
>  arch/x86/xen/enlighten.c         |    6 +-
>  arch/x86/xen/mmu.c               |  225 ++++++++++++++++++++++++++++++-
>  arch/x86/xen/setup.c             |    3 -
>  drivers/pci/Makefile             |    2 +
>  drivers/pci/xen-iommu.c          |  279 ++++++++++++++++++++++++++++++++++++++
>  drivers/xen/balloon.c            |   15 +--
>  include/xen/interface/memory.h   |   50 +++++++
>  include/xen/xen-ops.h            |    6 +
>  20 files changed, 671 insertions(+), 27 deletions(-)
>  create mode 100644 arch/x86/include/asm/xen/iommu.h
>  create mode 100644 arch/x86/pci/xen.c
>  create mode 100644 drivers/pci/xen-iommu.c
> 
> Thanks,
> 	J
