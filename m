Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZCEWd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZCEWd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZCEWdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:33:10 -0500
Received: from 8bytes.org ([88.198.83.132]:59159 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZCEWdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:33:06 -0500
Date: Thu, 5 Mar 2009 23:33:02 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][GIT PULL] dma-api debugging facility
Message-ID: <20090305223302.GN2125@8bytes.org>
References: <20090305200338.GA31182@amd.com> <20090306055944Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306055944Q.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 05:59:18AM +0900, FUJITA Tomonori wrote:
> On Thu, 5 Mar 2009 21:03:38 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi Ingo,
> > 
> > The following changes since commit 0bd5c4f7c874cf48ff7904dcf8a59988c8fea0e8:
> >   Ingo Molnar (1):
> >         Merge branch 'iommu/fixes-2.6.29' of git://git.kernel.org/.../joro/linux-2.6-iommu into core/iommu
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-api/debug
> > 
> > David Woodhouse (2):
> >       dma-debug: add function to dump dma mappings
> >       dma-debug: print stacktrace of mapping path on unmap error
> > 
> > Joerg Roedel (16):
> >       dma-debug: add Kconfig entry
> >       dma-debug: add header file and core data structures
> >       dma-debug: add hash functions for dma_debug_entries
> >       dma-debug: add allocator code
> >       dma-debug: add initialization code
> >       dma-debug: add kernel command line parameters
> >       dma-debug: add debugfs interface
> >       dma-debug: add core checking functions
> >       dma-debug: add checking for map/unmap_page/single
> >       dma-debug: add add checking for map/unmap_sg
> >       dma-debug: add checking for [alloc|free]_coherent
> >       dma-debug: add checks for sync_single_*
> >       dma-debug: add checks for sync_single_range_*
> >       dma-debug: add checks for sync_single_sg_*
> >       dma-debug: x86 architecture bindings
> >       dma-debug: Documentation update
> > 
> >  Documentation/DMA-API.txt           |  106 +++++
> >  Documentation/kernel-parameters.txt |   10 +
> >  arch/Kconfig                        |    2 +
> >  arch/x86/Kconfig                    |    1 +
> >  arch/x86/include/asm/dma-mapping.h  |   45 ++-
> >  arch/x86/kernel/pci-dma.c           |    6 +
> >  include/linux/dma-debug.h           |  167 +++++++
> >  lib/Kconfig.debug                   |   11 +
> >  lib/Makefile                        |    2 +
> >  lib/dma-debug.c                     |  870 +++++++++++++++++++++++++++++++++++
> >  10 files changed, 1214 insertions(+), 6 deletions(-)
> >  create mode 100644 include/linux/dma-debug.h
> >  create mode 100644 lib/dma-debug.c
> > 
> > A few changes were made since the v3 post of this code:
> > 
> > * new checks were added
> > * stack trace of mapping path is printed
> > * default number of preallocated entries has been increased to 32768 on
> >   x86 - in the latest tests I had more than 26000 dma-api allocations in
> >   the hash
> > * therefore the hash size has been increased to 1024
> 
> You have not posted patches that addressed some reviewed comments. For
> example, dma-debug's dma_map_sg support is just wrong:
> 
> http://marc.info/?l=linux-kernel&m=123556055325566&w=2

Thats fixed in the tree above. I will send out the patches tomorrow
seperatly for easier reviewing and commenting.

Joerg

