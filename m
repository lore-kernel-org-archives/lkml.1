Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYKUKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYKUKk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYKUKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:40:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:24161 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbYKUKkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:40:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=SmXM3Vc3gMHkznecsz1SZHd1d2nNPe8T7e/Hq0u48RhmORmIGh+3+MSlABpY7qbYQF
         l+/JKJ+YofUsKyEhrnKeaBZ4l0zZ8dhCsCK4C1yaBpf5b7HfljgvUYn/N8KYOwV0QDEL
         NrRL6jUgE4x8EEfiVSfJvJ1i6m87taa2mcE2M=
Message-ID: <a4423d670811210240t77ec97d1pbe1ef0e4ae3a1a2e@mail.gmail.com>
Date: Fri, 21 Nov 2008 13:40:39 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com
Subject: next-20081121:WARNING: at drivers/dma/dmaengine.c:665 dma_async_device_unregister()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It occured during shutdown process:

sd 0:2:0:0: [sda] Synchronizing SCSI cache
ioatdma 0000:00:08.0: Removing dma and dca services
------------[ cut here ]------------
WARNING: at drivers/dma/dmaengine.c:665 dma_async_device_unregister+0x90/0xd0()
dma_async_device_unregister called while 1 clients hold a reference
Modules linked in:
Pid: 12246, comm: reboot Tainted: G        W  2.6.28-rc5-next-20081121 #8
Call Trace:
 [<ffffffff80236b7c>] warn_slowpath+0xae/0xd5
 [<ffffffff80298414>] ? add_partial+0x1a/0x50
 [<ffffffff804588e6>] ? dma_async_device_unregister+0x22/0xd0
 [<ffffffff802576c4>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff804e4829>] ? __mutex_lock_common+0x371/0x3be
 [<ffffffff804588e6>] ? dma_async_device_unregister+0x22/0xd0
 [<ffffffff802576c4>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff80257805>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff804e4a51>] ? __mutex_unlock_slowpath+0x13c/0x145
 [<ffffffff80458954>] dma_async_device_unregister+0x90/0xd0
 [<ffffffff80459b62>] ioat_dma_remove+0x1c/0xd0
 [<ffffffff80459992>] ioat_shutdown_functionality+0x66/0x74
 [<ffffffff80388ad2>] pci_device_shutdown+0x24/0x38
 [<ffffffff803e042c>] device_shutdown+0x50/0x99
 [<ffffffff80245612>] kernel_restart_prepare+0x27/0x2e
 [<ffffffff80245652>] kernel_restart+0x11/0x44
 [<ffffffff802457af>] sys_reboot+0x11d/0x149
 [<ffffffff8024d3f1>] ? hrtimer_nanosleep+0x104/0x119
 [<ffffffff8024c9f6>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff804e4ab5>] ? do_nanosleep+0x50/0xb6
 [<ffffffff802576c4>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff804e583a>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b75b>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x66/0x68()
Device 'dma0chan0' does not have a release() function, it is broken and must be
fixed.
Modules linked in:
Pid: 12246, comm: reboot Tainted: G        W  2.6.28-rc5-next-20081121 #8
Call Trace:
 [<ffffffff80236b7c>] warn_slowpath+0xae/0xd5
 [<ffffffff802e4812>] ? release_sysfs_dirent+0x7d/0x9d
 [<ffffffff802e484a>] ? __sysfs_put+0x18/0x1a
 [<ffffffff802e4aa3>] ? sysfs_addrm_finish+0x233/0x27b
 [<ffffffff802af85f>] ? ifind+0x2c/0x84
 [<ffffffff80257805>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff804e44a4>] ? mutex_trylock+0x146/0x15a
 [<ffffffff802e4668>] ? sysfs_addrm_start+0x78/0xa5
 [<ffffffff802e4668>] ? sysfs_addrm_start+0x78/0xa5
 [<ffffffff8037657c>] ? kobj_kset_leave+0x1e/0x57
 [<ffffffff803e0b57>] device_release+0x66/0x68
 [<ffffffff8037663e>] kobject_release+0x52/0x68
 [<ffffffff803765ec>] ? kobject_release+0x0/0x68
 [<ffffffff80377429>] kref_put+0x43/0x4f
 [<ffffffff80376546>] kobject_put+0x47/0x4b
 [<ffffffff803e048a>] put_device+0x15/0x17
 [<ffffffff803e12a3>] device_unregister+0x19/0x1e
 [<ffffffff80458968>] dma_async_device_unregister+0xa4/0xd0
 [<ffffffff80459b62>] ioat_dma_remove+0x1c/0xd0
 [<ffffffff80459992>] ioat_shutdown_functionality+0x66/0x74
 [<ffffffff80388ad2>] pci_device_shutdown+0x24/0x38
 [<ffffffff803e042c>] device_shutdown+0x50/0x99
 [<ffffffff80245612>] kernel_restart_prepare+0x27/0x2e
 [<ffffffff80245652>] kernel_restart+0x11/0x44
 [<ffffffff802457af>] sys_reboot+0x11d/0x149
 [<ffffffff8024d3f1>] ? hrtimer_nanosleep+0x104/0x119
 [<ffffffff8024c9f6>] ? hrtimer_wakeup+0x0/0x21
 [<ffffffff804e4ab5>] ? do_nanosleep+0x50/0xb6
 [<ffffffff802576c4>] ? trace_hardirqs_on_caller+0x1f/0x153
 [<ffffffff804e583a>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020b75b>] system_call_fastpath+0x16/0x1b
---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
WARNING: at drivers/base/core.c:122 device_release+0x66/0x68()
Device 'dma0chan1' does not have a release() function, it is broken and must be
fixed.
Modules linked in:
Pid: 12246, comm: reboot Tainted: G        W  2.6.28-rc5-next-20081121 #8


I guess it was tainted by previous warning on hpet:

hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2bf/0x36d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28-rc5-next-20081121 #8
Call Trace:
