Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZEZJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZEZJaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZEZJan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:30:43 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16028
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753090AbZEZJam convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:30:42 -0400
X-BigFish: VPS-12(z21eWzzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KK8VQV-02-7OM-01
Date: Tue, 26 May 2009 11:30:28 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
CC: osrc-patches@elbe.amd.com
Subject: [git pull] amd-iommu updates for 2.6.31
Message-ID: <20090526093028.GA3927@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 May 2009 09:30:28.0959 (UTC) FILETIME=[9B99A6F0:01C9DDE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 41fb454ebe6024f5c1e3b3cbc0abc0da762e7b51:
  Ingo Molnar (1):
        Merge commit 'v2.6.30-rc5' into core/iommu

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.31

Chris Wright (1):
      amd iommu: properly detach from protection domain on ->remove

Joerg Roedel (30):
      amd-iommu: make sure only ivmd entries are parsed
      amd-iommu: add amd_iommu_dump parameter
      amd-iommu: add dump for iommus described in ivrs table
      amd-iommu: print ivhd information to dmesg when requested
      amd-iommu: print ivmd information to dmesg when requested
      amd-iommu: move protection domain printk to dump code
      x86/iommu: add IOMMU_STRESS Kconfig entry
      amd-iommu: disable device isolation with CONFIG_IOMMU_STRESS
      amd-iommu: introduce for_each_iommu* macros
      amd-iommu: consolidate hardware initialization to one function
      amd-iommu: drop pointless iommu-loop in msi setup code
      amd-iommu: remove support for msi-x
      amd-iommu: add function to disable all iommus
      amd-iommu: add function to flush tlb for all domains
      amd-iommu: add function to flush tlb for all devices
      amd_iommu: un __init functions required for suspend/resume
      amd-iommu: implement suspend/resume
      amd-iommu: introduce aperture_range structure
      amd-iommu: move page table allocation code to seperate function
      amd-iommu: handle page table allocation failures in dma_ops code
      amd-iommu: make address allocator aware of multiple aperture ranges
      amd-iommu: change dma_dom->next_bit to dma_dom->next_address
      amd-iommu: move aperture_range allocation code to seperate function
      amd-iommu: handle exlusion ranges and unity mappings in alloc_new_range
      amd-iommu: enlarge the aperture dynamically
      amd-iommu: remove amd_iommu_size kernel parameter
      amd-iommu: disable round-robin allocator for CONFIG_IOMMU_STRESS
      amd-iommu: don't preallocate page tables with CONFIG_IOMMU_STRESS
      amd-iommu: don't free dma adresses below 512MB with CONFIG_IOMMU_STRESS
      Merge branches 'amd-iommu/fixes', 'amd-iommu/debug', 'amd-iommu/suspend-resume' and 'amd-iommu/extended-allocator' into amd-iommu/2.6.31

Neil Turton (2):
      amd-iommu: fix an off-by-one error in the AMD IOMMU driver.
      amd-iommu: fix the handling of device aliases in the AMD IOMMU driver.

 Documentation/kernel-parameters.txt    |    5 -
 arch/x86/Kconfig.debug                 |    8 +
 arch/x86/include/asm/amd_iommu.h       |    2 +
 arch/x86/include/asm/amd_iommu_types.h |   55 +++-
 arch/x86/kernel/amd_iommu.c            |  490 ++++++++++++++++++++++++--------
 arch/x86/kernel/amd_iommu_init.c       |  274 ++++++++++++------
 6 files changed, 603 insertions(+), 231 deletions(-)

The updates contain two major enhancements. First one is support for
suspend/resume with iommu enabled. The second one is an extended
allocator for DMA adresses. The new allocator grows the DMA address
space in a dma_ops domain dynamically from a 128MB default size to a
maximum of 4GB as required.
Some fixes are also included. Another new feature is the introduction of
CONFIG_IOMMU_STRESS. This feature is indended for randconfig based iommu
code testing. For AMD IOMMU it disables some optimizations to
stress-test the code. Please pull.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

