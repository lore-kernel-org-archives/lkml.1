Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0BBI0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:26:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35682 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab0BBI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:26:04 -0500
Date: Tue, 2 Feb 2010 08:25:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
In-Reply-To: <20100202081727.GA6788@elte.hu>
Message-ID: <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie> <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie> <20100202081727.GA6788@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> It's the moving of radeom KMS out of staging after -rc6 that causes it, 
> because it brought it into the scope of my testing:
> 
>  f71d018: drm/radeon/kms: move radeon KMS on/off switch out of staging.
> 
> So at least on this box it's clearly not ready for mainline enablement yet. 
> I've attached the revert patch further below.
> 

Its not enabled by default so reverting this doesn't make much sense.

We can just treat this as a normal driver bugreport.

Dave.

> 	Ingo
> 
> -------------------->
> [    6.864061] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
> [    6.871010] radeon 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 5
> [    6.878014] radeon 0000:01:00.0: setting latency timer to 64
> [    6.885950] device: 'controlD64': device_add
> [    6.890221] device: 'card0': device_add
> [    6.894100] [drm] radeon: Initializing kernel modesetting.
> [    6.900042] radeon 0000:01:00.0: using 40bit DMA mask
> [    6.905018] [drm] register mmio base: 0xD9000000
> [    6.910004] [drm] register mmio size: 65536
> [    6.916147] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
> [    6.917049] [drm] Generation 2 PCI interface, using max accessible memory
> [    6.918004] [drm] radeon: VRAM 128M
> [    6.919003] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
> [    6.920005] [drm] radeon: GTT 512M
> [    6.921003] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
> [    6.922241]   alloc irq_desc for 24 on node -1
> [    6.922999]   alloc kstat_irqs on node -1
> [    6.923036] radeon 0000:01:00.0: irq 24 for MSI/MSI-X
> [    6.924028] [drm] radeon: using MSI.
> [    6.925133] [drm] radeon: irq initialized.
> [    6.926009] [drm] Detected VRAM RAM=128M, BAR=128M
> [    6.927003] [drm] RAM width 64bits DDR
> [    6.929249] [TTM] Zone  kernel: Available graphics memory: 434560 kiB.
> [    6.930010] [TTM] Zone highmem: Available graphics memory: 506212 kiB.
> [    6.931200] [drm] radeon: 128M of VRAM memory ready
> [    6.932005] [drm] radeon: 512M of GTT memory ready.
> [    6.933094] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [    6.935508] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
> [    6.936033] [drm] PCIE GART of 512M enabled (table at 0x00040000).
> [    6.937068] [drm] radeon: cp idle (0x10000C03)
> [    6.938011] Registering platform device 'radeon_cp.0'. Parent at platform
> [    6.939005] device: 'radeon_cp.0': device_add
> [    6.940018] bus: 'platform': add device radeon_cp.0
> [    6.941122] [drm] Loading R300 Microcode
> [    6.942009] platform radeon_cp.0: firmware: using built-in firmware radeon/R300_cp.bin
> [    6.943023] bus: 'platform': remove device radeon_cp.0
> [    6.945161] [drm] radeon: ring at 0x0000000020000000
> [    7.108115] [drm:r100_ring_test] *ERROR* radeon: ring test failed (sracth(0x15E4)=0xCAFEDEAD)
> [    7.109004] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-22).
> [    7.110003] radeon 0000:01:00.0: failled initializing CP (-22).
> [    7.111003] radeon 0000:01:00.0: Disabling GPU acceleration
> [    7.273547] Failed to wait GUI idle while programming pipes. Bad things might happen.
> [    7.436296] [drm:r100_cp_fini] *ERROR* Wait for CP idle timeout, shutting down CP.
> [    7.598755] Failed to wait GUI idle while programming pipes. Bad things might happen.
> [    7.599306] BUG: unable to handle kernel paging request at f8380000
> [    7.599999] IP: [<c149f0de>] rv370_pcie_gart_set_page+0x2d/0x3c
> [    7.599999] *pde = 36d44067 *pte = 00000000 
> [    7.599999] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [    7.599999] last sysfs file: 
> [    7.599999] 
> [    7.599999] Pid: 1, comm: swapper Not tainted 2.6.33-rc6-00066-g9ce9290-dirty #14391 A8N-E/System Product Name
> [    7.599999] EIP: 0060:[<c149f0de>] EFLAGS: 00010206 CPU: 0
> [    7.599999] EIP is at rv370_pcie_gart_set_page+0x2d/0x3c
> [    7.599999] EAX: 0000000c EBX: 00000000 ECX: f8380000 EDX: f8380000
> [    7.599999] ESI: 00000000 EDI: 00000001 EBP: f6c33d68 ESP: f6c33d60
> [    7.599999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    7.599999] Process swapper (pid: 1, ti=f6c32000 task=f6c30000 task.ti=f6c32000)
> [    7.599999] Stack:
> [    7.599999]  f6a1f004 00000000 f6c33d90 c14899fb 00000000 00000000 00000100 00000000
> [    7.599999] <0> 00000000 f6a06538 00000000 00000002 f6c33d9c c1488467 f6a06500 f6c33da8
> [    7.599999] <0> c14628ad f6a12af0 f6c33dd0 c146413a 00000000 c20d0d00 f6a1f364 f6a1f364
> [    7.599999] Call Trace:
> [    7.599999]  [<c14899fb>] ? radeon_gart_unbind+0xb7/0xdf
> [    7.599999]  [<c1488467>] ? radeon_ttm_backend_unbind+0x14/0x1d
> [    7.599999]  [<c14628ad>] ? ttm_tt_unbind+0x15/0x27
> [    7.599999]  [<c146413a>] ? ttm_bo_cleanup_refs+0xe0/0x1e8
> [    7.599999]  [<c1465717>] ? ttm_bo_release+0x4c/0x65
> [    7.599999]  [<c14656cb>] ? ttm_bo_release+0x0/0x65
> [    7.599999]  [<c13bbda5>] ? kref_put+0x39/0x42
> [    7.599999]  [<c1464357>] ? ttm_bo_unref+0x27/0x32
> [    7.599999]  [<c148947f>] ? radeon_bo_unref+0x1d/0x2d
> [    7.599999]  [<c1495fd6>] ? radeon_ring_fini+0x55/0x74
> [    7.599999]  [<c149d70d>] ? r100_cp_fini+0x5d/0x82
> [    7.599999]  [<c14a1a03>] ? r300_init+0x1c5/0x20f
> [    7.599999]  [<c147d680>] ? radeon_device_init+0x227/0x29f
> [    7.599999]  [<c147df0a>] ? radeon_driver_load_kms+0x9d/0xff
> [    7.599999]  [<c145aa62>] ? drm_get_dev+0x28a/0x364
> [    7.599999]  [<c1aabbe0>] ? radeon_pci_probe+0xd/0xf
> [    7.599999]  [<c13dc6a6>] ? local_pci_probe+0xe/0x10
> [    7.599999]  [<c13dc86f>] ? pci_device_probe+0x43/0x66
> [    7.599999]  [<c14cdaf8>] ? driver_probe_device+0xae/0x13e
> [    7.599999]  [<c14cdbcb>] ? __driver_attach+0x43/0x5f
> [    7.599999]  [<c14cd46e>] ? bus_for_each_dev+0x3d/0x67
> [    7.599999]  [<c14cd954>] ? driver_attach+0x14/0x16
> [    7.599999]  [<c14cdb88>] ? __driver_attach+0x0/0x5f
> [    7.599999]  [<c14cceb7>] ? bus_add_driver+0xab/0x1d1
> [    7.599999]  [<c14cddf7>] ? driver_register+0x79/0xe0
> [    7.599999]  [<c13ced32>] ? __raw_spin_lock_init+0x28/0x4e
> [    7.599999]  [<c13dca4a>] ? __pci_register_driver+0x4c/0xa9
> [    7.599999]  [<c14570ad>] ? drm_init+0x5a/0xb2
> [    7.599999]  [<c217d557>] ? radeon_init+0x0/0xae
> [    7.599999]  [<c217d603>] ? radeon_init+0xac/0xae
> [    7.599999]  [<c1001051>] ? do_one_initcall+0x4c/0x159
> [    7.599999]  [<c215830a>] ? kernel_init+0x112/0x163
> [    7.599999]  [<c21581f8>] ? kernel_init+0x0/0x163
> [    7.599999]  [<c10210ba>] ? kernel_thread_helper+0x6/0x10
> [    7.599999] Code: d2 89 e5 56 8b 75 08 53 8b 5d 0c 8b 88 48 02 00 00 78 1e 3b 90 38 02 00 00 77 16 89 f0 c1 e8 08 83 c8 0c c1 e3 18 09 d8 8d 14 91 <89> 02 31 c0 eb 05 b8 ea ff ff ff 5b 5e 5d c3 83 78 50 09 55 89 
> [    7.599999] EIP: [<c149f0de>] rv370_pcie_gart_set_page+0x2d/0x3c SS:ESP 0068:f6c33d60
> [    7.599999] CR2: 00000000f8380000
> [    7.599999] ---[ end trace 012a361324455360 ]---
> [    7.599999] Kernel panic - not syncing: Fatal exception
> [    7.599999] Pid: 1, comm: swapper Tainted: G      D    2.6.33-rc6-00066-g9ce9290-dirty #14391
> 
> >From 2f73a756d3603067c0dc618683f8515ef2fbae34 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 2 Feb 2010 09:06:04 +0100
> Subject: [PATCH] Revert "drm/radeon/kms: move radeon KMS on/off switch out of staging."
> 
> This reverts commit f71d0187987e691516cd10c2702f002c0e2f0edc.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/gpu/drm/Kconfig |    2 --
>  drivers/staging/Kconfig |    2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 305c590..96eddd1 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -66,8 +66,6 @@ config DRM_RADEON
>  
>  	  If M is selected, the module will be called radeon.
>  
> -source "drivers/gpu/drm/radeon/Kconfig"
> -
>  config DRM_I810
>  	tristate "Intel I810"
>  	depends on DRM && AGP && AGP_INTEL
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index fc2e963..94eb863 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -99,6 +99,8 @@ source "drivers/staging/line6/Kconfig"
>  
>  source "drivers/gpu/drm/vmwgfx/Kconfig"
>  
> +source "drivers/gpu/drm/radeon/Kconfig"
> +
>  source "drivers/gpu/drm/nouveau/Kconfig"
>  
>  source "drivers/staging/octeon/Kconfig"
> 
