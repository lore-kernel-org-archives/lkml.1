Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZBKSoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZBKSoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZBKSn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:43:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:55917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZBKSnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:43:55 -0500
Subject: [git-pull -tip] fix compilation warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       airlied@linux.ie
Content-Type: text/plain
Date: Thu, 12 Feb 2009 00:13:17 +0530
Message-Id: <1234377797.3910.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5765fcf36081bafa06b9553376bd99ceb629beb8:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git master

Jaswinder Singh Rajput (5):
      x86: mm/init_32.c fix compilation warning
      x86: kernel/mpparse.c fix compilation warnings
      drm_proc.c fix compilation warning
      falcon fix compilation warnings
      iscsi_ibft.c fix compilation warning

 arch/x86/kernel/mpparse.c     |    6 +++---
 arch/x86/mm/init_32.c         |    2 +-
 drivers/firmware/iscsi_ibft.c |    4 ++--
 drivers/gpu/drm/drm_proc.c    |    4 ++--
 drivers/net/sfc/falcon.c      |   24 ++++++++++++------------
 5 files changed, 20 insertions(+), 20 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 66ebb82..2007644 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -692,8 +692,8 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 #endif
 			mpf_found = mpf;
 
-			printk(KERN_INFO "found SMP MP-table at [%p] %08lx\n",
-			       mpf, virt_to_phys(mpf));
+			printk(KERN_INFO "found SMP MP-table at [%p] %llx\n",
+			       mpf, (u64)virt_to_phys(mpf));
 
 			if (!reserve)
 				return 1;
@@ -1011,7 +1011,7 @@ static int __init update_mp_table(void)
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
-	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
+	printk(KERN_INFO "mpf: %llx\n", (u64)virt_to_phys(mpf));
 	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 41b3545..21d34b3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -691,7 +691,7 @@ void __init find_low_pfn_range(void)
 			max_pfn = MAXMEM_PFN + highmem_pages;
 		if (highmem_pages + MAXMEM_PFN > max_pfn) {
 			printk(KERN_WARNING "only %luMB highmem pages "
-				"available, ignoring highmem size of %uMB.\n",
+				"available, ignoring highmem size of %luMB.\n",
 				pages_to_mb(max_pfn - MAXMEM_PFN),
 				pages_to_mb(highmem_pages));
 			highmem_pages = 0;
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 3ab3e4a..7b7ddc2 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -938,8 +938,8 @@ static int __init ibft_init(void)
 		return -ENOMEM;
 
 	if (ibft_addr) {
-		printk(KERN_INFO "iBFT detected at 0x%lx.\n",
-		       virt_to_phys((void *)ibft_addr));
+		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
+		       (u64)virt_to_phys((void *)ibft_addr));
 
 		rc = ibft_check_device();
 		if (rc)
diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index 8df849f..b756f04 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -678,9 +678,9 @@ static int drm__vma_info(char *buf, char **start, off_t offset, int request,
 	*start = &buf[offset];
 	*eof = 0;
 
-	DRM_PROC_PRINT("vma use count: %d, high_memory = %p, 0x%08lx\n",
+	DRM_PROC_PRINT("vma use count: %d, high_memory = %p, 0x%llx\n",
 		       atomic_read(&dev->vma_count),
-		       high_memory, virt_to_phys(high_memory));
+		       high_memory, (u64)virt_to_phys(high_memory));
 	list_for_each_entry(pt, &dev->vmalist, head) {
 		if (!(vma = pt->vma))
 			continue;
diff --git a/drivers/net/sfc/falcon.c b/drivers/net/sfc/falcon.c
index d5378e6..064307c 100644
--- a/drivers/net/sfc/falcon.c
+++ b/drivers/net/sfc/falcon.c
@@ -338,10 +338,10 @@ static int falcon_alloc_special_buffer(struct efx_nic *efx,
 	nic_data->next_buffer_table += buffer->entries;
 
 	EFX_LOG(efx, "allocating special buffers %d-%d at %llx+%x "
-		"(virt %p phys %lx)\n", buffer->index,
+		"(virt %p phys %llx)\n", buffer->index,
 		buffer->index + buffer->entries - 1,
-		(unsigned long long)buffer->dma_addr, len,
-		buffer->addr, virt_to_phys(buffer->addr));
+		(u64)buffer->dma_addr, len,
+		buffer->addr, (u64)virt_to_phys(buffer->addr));
 
 	return 0;
 }
@@ -353,10 +353,10 @@ static void falcon_free_special_buffer(struct efx_nic *efx,
 		return;
 
 	EFX_LOG(efx, "deallocating special buffers %d-%d at %llx+%x "
-		"(virt %p phys %lx)\n", buffer->index,
+		"(virt %p phys %llx)\n", buffer->index,
 		buffer->index + buffer->entries - 1,
-		(unsigned long long)buffer->dma_addr, buffer->len,
-		buffer->addr, virt_to_phys(buffer->addr));
+		(u64)buffer->dma_addr, buffer->len,
+		buffer->addr, (u64)virt_to_phys(buffer->addr));
 
 	pci_free_consistent(efx->pci_dev, buffer->len, buffer->addr,
 			    buffer->dma_addr);
@@ -2343,10 +2343,10 @@ int falcon_probe_port(struct efx_nic *efx)
 				 FALCON_MAC_STATS_SIZE);
 	if (rc)
 		return rc;
-	EFX_LOG(efx, "stats buffer at %llx (virt %p phys %lx)\n",
-		(unsigned long long)efx->stats_buffer.dma_addr,
+	EFX_LOG(efx, "stats buffer at %llx (virt %p phys %llx)\n",
+		(u64)efx->stats_buffer.dma_addr,
 		efx->stats_buffer.addr,
-		virt_to_phys(efx->stats_buffer.addr));
+		(u64)virt_to_phys(efx->stats_buffer.addr));
 
 	return 0;
 }
@@ -2921,9 +2921,9 @@ int falcon_probe_nic(struct efx_nic *efx)
 		goto fail4;
 	BUG_ON(efx->irq_status.dma_addr & 0x0f);
 
-	EFX_LOG(efx, "INT_KER at %llx (virt %p phys %lx)\n",
-		(unsigned long long)efx->irq_status.dma_addr,
-		efx->irq_status.addr, virt_to_phys(efx->irq_status.addr));
+	EFX_LOG(efx, "INT_KER at %llx (virt %p phys %llx)\n",
+		(u64)efx->irq_status.dma_addr,
+		efx->irq_status.addr, (u64)virt_to_phys(efx->irq_status.addr));
 
 	falcon_probe_spi_devices(efx);
 


