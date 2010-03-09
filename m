Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0CILPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:15:33 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:7656 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754541Ab0CILP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:15:29 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz9370Jzz1202hzzz32i6bh2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ0HVZ-02-1GD-02
X-M-MSG: 
Date: Tue, 9 Mar 2010 12:14:21 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [git pull] IOMMU fixes and updates
Message-ID: <20100309111421.GE5619@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Mar 2010 11:14:22.0404 (UTC) FILETIME=[AB942040:01CABF79]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I know that this pull-request comes too late, but these changes had kvm
dependencies (this is the reason I didn't sent these changes via Ingo).
The KVM changes appeared in your tree last friday and as I checked my
prepared branch against the result I found out that the KVM people
rebased the branch I put the largepage changes on. So I had to rebase my
largepage branch too to eliminate the old commits and put a new
pull-branch together.
Sadly the KVM branch was rebased to some stage of your tree in the merge
window which didn't even boot my test machine. So I spent the whole day
yesterday to get the result booting and tested. After finding the reason
for the boot crash I passed this issue to Boris which sent a fix for
this one (see http://lkml.org/lkml/2010/3/8/199). Here is the
tested result. With Boris fix it boots and has no know regressions.
Please consider to pull these changes. If you decide thats too late to
pull this it has to wait for the next merge window.

Anyway:

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/updates-2.6.34

Chris Wright (1):
      x86/amd-iommu: Pt mode fix for domain_destroy

Joerg Roedel (14):
      x86/amd-iommu: Protect IOMMU-API map/unmap path
      x86/amd-iommu: Report errors in acpi parsing functions upstream
      iommu-api: Rename ->{un}map function pointers to ->{un}map_range
      iommu-api: Add iommu_map and iommu_unmap functions
      iommu-api: Add ->{un}map callbacks to iommu_ops
      VT-d: Change {un}map_range functions to implement {un}map interface
      kvm: Change kvm_iommu_map_pages to map large pages
      x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
      x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
      x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
      x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
      iommu-api: Remove iommu_{un}map_range functions
      x86/amd-iommu: Use helper function to destroy domain
      Merge branches 'iommu/largepages' and 'amd-iommu/fixes' into iommu/updates-2.6.34

Julia Lawall (1):
      x86/amd-iommu: Remove double NULL check in check_device

 arch/x86/include/asm/amd_iommu_types.h |   36 ++++++
 arch/x86/kernel/amd_iommu.c            |  210 +++++++++++++++++++++-----------
 arch/x86/kernel/amd_iommu_init.c       |   38 ++++--
 drivers/base/iommu.c                   |   43 +++++--
 drivers/pci/intel-iommu.c              |   22 ++--
 include/linux/iommu.h                  |   24 ++--
 virt/kvm/iommu.c                       |  113 ++++++++++++++----
 7 files changed, 343 insertions(+), 143 deletions(-)


