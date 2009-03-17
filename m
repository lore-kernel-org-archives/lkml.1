Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbZCQMBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbZCQMBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCQMBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:01:36 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:11349
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754777AbZCQMBf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:01:35 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGNG20-03-8WD-01
Date: Tue, 17 Mar 2009 13:01:12 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dma-debug: add additional checks
Message-ID: <20090317120112.GP6159@amd.com>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Mar 2009 12:01:12.0988 (UTC) FILETIME=[115875C0:01C9A6F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 06:05:27PM +0100, Joerg Roedel wrote:
> Hi,
> 
> this small series of patches adds three additional checks to the dma-api
> debugging code. The first one checks if dma mappings are requested for
> kernel text or rodata segments.
> The second check added makes noise if a device is unbound from its
> driver and there are still pending dma allocations we are aware of.
> 
> Joerg
> 
> diffstat:
> 
>  arch/x86/kernel/pci-dma.c |    4 ++
>  include/linux/dma-debug.h |    7 ++++
>  lib/dma-debug.c           |   81 ++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 91 insertions(+), 1 deletions(-)

Ingo,

you can also pull these patches from my dma-api/debug branch at

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git dma-api/debug

including the other dma-debug patches relative to your tip/core/iommu
branch.

The complete diffstat and shortlog against tip/core/iommu is here:

 Documentation/DMA-API.txt           |  106 ++++
 Documentation/kernel-parameters.txt |   10 +
 arch/Kconfig                        |    2 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/dma-mapping.h  |   45 ++-
 arch/x86/kernel/pci-dma.c           |   10 +
 include/linux/dma-debug.h           |  174 +++++++
 lib/Kconfig.debug                   |   11 +
 lib/Makefile                        |    2 +
 lib/dma-debug.c                     |  949 +++++++++++++++++++++++++++++++++++
 10 files changed, 1304 insertions(+), 6 deletions(-)

David Woodhouse (2):
      dma-debug: add function to dump dma mappings
      dma-debug: print stacktrace of mapping path on unmap error

Joerg Roedel (19):
      dma-debug: add Kconfig entry
      dma-debug: add header file and core data structures
      dma-debug: add hash functions for dma_debug_entries
      dma-debug: add allocator code
      dma-debug: add initialization code
      dma-debug: add kernel command line parameters
      dma-debug: add debugfs interface
      dma-debug: add core checking functions
      dma-debug: add checking for map/unmap_page/single
      dma-debug: add add checking for map/unmap_sg
      dma-debug: add checking for [alloc|free]_coherent
      dma-debug: add checks for sync_single_*
      dma-debug: add checks for sync_single_range_*
      dma-debug: add checks for sync_single_sg_*
      dma-debug: x86 architecture bindings
      dma-debug: Documentation update
      dma-debug: add checks for kernel text and rodata
      dma-debug: add a check dma memory leaks
      dma-debug/x86: register pci bus for dma-debug leak detection

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

