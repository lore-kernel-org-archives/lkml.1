Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZIDNGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZIDNGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbZIDNGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:06:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbZIDNGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:06:47 -0400
Date: Fri, 4 Sep 2009 15:06:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, osrc-patches@elbe.amd.com
Subject: Re: [git pull] AMD-IOMMU (AMD-Vi) updates for 2.6.32
Message-ID: <20090904130645.GB9490@elte.hu>
References: <20090904100506.GD30765@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904100506.GD30765@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi Ingo,
> 
> The following changes since commit 37d0892c5a94e208cf863e3b7bac014edee4346d:
>   Ian Kent (1):
>         autofs4 - fix missed case when changing to use struct path
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.32
> 
> Joerg Roedel (37):
>       x86/amd-iommu: Dump fault entry on DTE error
>       x86/amd-iommu: Dump illegal command on ILLEGAL_COMMAND_ERROR
>       x86/amd-iommu: Introduce function for iommu-local domain flush
>       x86/amd-iommu: Remove some merge helper code
>       x86/amd-iommu: replace "AMD IOMMU" by "AMD-Vi"
>       x86/amd-iommu: Remove redundant 'IOMMU' string
>       x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices
>       x86/amd-iommu: Add function to flush all DTEs on one IOMMU
>       x86/amd-iommu: Add reset function for command buffers
>       x86/amd-iommu: Reset command buffer on ILLEGAL_COMMAND_ERROR
>       x86/amd-iommu: Panic if IOMMU command buffer reset fails
>       x86/amd-iommu: Reset command buffer if wait loop fails
>       x86/amd-iommu: Make fetch_pte aware of dynamic mapping levels
>       x86/amd-iommu: Use fetch_pte in iommu_unmap_page
>       x86/amd-iommu: Use fetch_pte in amd_iommu_iova_to_phys
>       x86/amd-iommu: Add a gneric version of amd_iommu_flush_all_devices
>       x86/amd-iommu: Introduce set_dte_entry function
>       x86/amd-iommu: Flush domains if address space size was increased
>       x86/amd-iommu: Introduce increase_address_space function
>       x86/amd-iommu: Change alloc_pte to support 64 bit address space
>       x86/amd-iommu: Remove last usages of IOMMU_PTE_L0_INDEX
>       x86/amd-iommu: Remove bus_addr check in iommu_map_page
>       x86/amd-iommu: Use 2-level page tables for dma_ops domains
>       x86/amd-iommu: Remove old page table handling macros
>       x86/amd-iommu: Support higher level PTEs in iommu_page_unmap
>       x86/amd-iommu: Change iommu_map_page to support multiple page sizes
>       x86/dma: Mark iommu_pass_through as __read_mostly
>       x86/amd-iommu: Add core functions for pd allocation/freeing
>       x86/amd-iommu: Add passthrough mode initialization functions
>       x86/amd-iommu: Fix device table write order
>       x86/amd-iommu: Align locking between attach_device and detach_device
>       x86/amd-iommu: Make sure a device is assigned in passthrough mode
>       x86/amd-iommu: Don't detach device from pt domain on driver unbind
>       x86/amd-iommu: Initialize passthrough mode when requested
>       Merge branches 'gart/fixes', 'amd-iommu/fixes+cleanups' and 'amd-iommu/fault-handling' into amd-iommu/2.6.32
>       Merge branch 'amd-iommu/passthrough' into amd-iommu/2.6.32
>       Merge branch 'amd-iommu/pagetable' into amd-iommu/2.6.32
> 
> Pavel Vasilyev (1):
>       x86/gart: Do not select AGP for GART_IOMMU
> 
>  arch/x86/Kconfig                       |    1 -
>  arch/x86/include/asm/amd_iommu.h       |    1 +
>  arch/x86/include/asm/amd_iommu_types.h |   50 ++--
>  arch/x86/kernel/amd_iommu.c            |  489 +++++++++++++++++++++++---------
>  arch/x86/kernel/amd_iommu_init.c       |   42 ++-
>  arch/x86/kernel/pci-dma.c              |    9 +-
>  6 files changed, 429 insertions(+), 163 deletions(-)
> 
> These changes include updates and improvements in the page table code,
> in fault handling and they implement iommu=pt mode for AMD-Vi too.
> Last but not least there are also some minor cleanups and fixes for
> AMD-Vi and GART included in this pull-request. All these changes are
> compile-, boot- and load-tested.
> 
> I had to do three merge commits for this pull request because the
> amd-iommu/passthrough and amd-iommu/pagetable branches touch the same
> code in some parts and the octopus merge of these branches failed. I had
> to merge these two branches seperatly.
> Please consider to pull.

Pulled, thanks a lot Joerg!

A few (small) comments:

+static void dump_dte_entry(u16 devid)
+{
+       int i;
+
+       for (i = 0; i < 8; ++i)
+               pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
+                       amd_iommu_dev_table[devid].data[i]);

that 8 is not very obvious - it deserves a comment. (we allocate at 
least one page to amd_iommu_dev_table[] so it's safe - but where the 
8 comes from is not very clear.)

Also, we tend to write 'i++' not '++i' in loops. (there's other 
examples of this too in the iommu files)

This log printing pattern:

        printk(KERN_ERR "AMD-Vi: Event logged [");

        switch (type) {
        case EVENT_TYPE_ILL_DEV:
                printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
                       "address=0x%016llx flags=0x%04x]\n",

is now broken (produces an unexpected newline) due to:

  5fd29d6: printk: clean up handling of log-levels and newlines

you probably want to convert all printk's to pr_*() calls, and use 
pr_cont() in the above place.

Similar comments hold for dump_command() as well.

+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -457,4 +457,7 @@ static inline void amd_iommu_stats_init(void) { 
}
 
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
+/* some function prototypes */
+extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
+

function prototypes belong into amd_iommu.h, not amd_iommu_types.h.

there's also a lot of function prototypes declared in the .c file:

+++ b/arch/x86/kernel/amd_iommu.c
@@ -61,6 +61,7 @@ static u64* alloc_pte(struct protection_domain 
*dom,
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
                                      unsigned long start_page,
                                      unsigned int pages);
+static void reset_iommu_command_buffer(struct amd_iommu *iommu);

These can generally be avoided via cleaner ordering: first define 
simpler functions then more complex ones (which rely on simpler 
functions).

+       if (unlikely(i == EXIT_LOOP_COUNT)) {
+               spin_unlock(&iommu->lock);
+               reset_iommu_command_buffer(iommu);
+               spin_lock(&iommu->lock);
+       }

What did iommu->lock protect it here, why do we drop it, and why is 
it necessary to take it again? This pattern shows that either 
there's too much or too little locking.

+       /* increase reference counter */
+       domain->dev_cnt += 1;

use ++?

+ * If a device is not yet associated with a domain, this function does
+ * assigns it visible for the hardware

typo.

+static void update_domain(struct protection_domain *domain)
+{
+       if (!domain->updated)
+               return;
+
+       update_device_table(domain);
+       flush_devices_by_domain(domain);
+       iommu_flush_domain(domain->id);
+
+       domain->updated = false;
+}

the domain->updated is a bit weird naming. Perhaps 
domain->update_needed?

+               iommu_unmap_page(domain, iova, PM_MAP_4k);

small nit: mixed-case letters - PM_MAP_4K is better i guess.

+#define PM_ALIGNED(lvl, addr)  ((PM_MAP_MASK(lvl) & (addr)) == (addr))

macro with two uses of its parameter - this is side-effect-unsafe. 
Safer would be to turn this into an inline function. That would also 
do proper type checking.

+       /* allocate passthroug domain */

typo.

+/*****************************************************************************
+ *
+ * The next functions do a basic initialization of IOMMU for pass through
+ * mode
+ *
+ * In passthrough mode the IOMMU is initialized and enabled but not used for
+ * DMA-API translation.
+ *
+ 
*****************************************************************************/

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

+#define PD_PASSTHROUGH_MASK    (1UL << 2) /* domain has no page
+                                             translation */

ditto.

+       domain->dev_cnt += 1;

Could use '++' here too.

Thanks,

	Ingo
