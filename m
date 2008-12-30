Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYL3NbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYL3NbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYL3NbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:31:17 -0500
Received: from [78.227.24.35] ([78.227.24.35]:42711 "HELO
	briare1.fullpliant.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1751709AbYL3NbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:31:16 -0500
X-Greylist: delayed 705 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2008 08:31:15 EST
From: Hubert Tonneau <hubert.tonneau@fullpliant.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: i915 KMS framebuffer oops report
Date: Tue, 30 Dec 2008 14:21:44 GMT
Message-ID: <08IR6K911@briare1.fullpliant.org>
X-Mailer: Pliant 105
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tested the GIT tree submitted by Airlied for inclusion
in 2.6.29, and just got an oops when trying to load i915
with kernel mode setting:

<6>Linux agpgart interface v0.103
<6>agpgart-intel 0000:00:00.0: Intel 945GM Chipset
<6>agpgart-intel 0000:00:00.0: detected 7932K stolen memory
<6>agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
<6>[drm] Initialized drm 1.1.0 20060810
<6>pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>pci 0000:00:02.0: setting latency timer to 64
<1>BUG: unable to handle kernel NULL pointer dereference at 00000000
<1>IP: [<00000000>] 0x0
<4>*pde = 00000000 
<0>Oops: 0000 [#1] SMP 
<0>last sysfs file: 
<4>Modules linked in: i915(+) cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit drm i2c_core intel_agp agpgart
<4>
<4>Pid: 1420, comm: insmod Not tainted (2.6.28 #1) Latitude D820                   
<4>EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 1
<4>EIP is at 0x0
<4>EAX: 00000000 EBX: c1fbc2a0 ECX: c2008500 EDX: c1fbc2a0
<4>ESI: 00000000 EDI: f6f64148 EBP: 00000000 ESP: f648bca8
<4> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
<0>Process insmod (pid: 1420, ti=f648a000 task=f6fcd8d0 task.ti=f648a000)
<0>Stack:
<4> c0152fe0 000000d0 00000000 00000000 00000000 00000000 f6f64148 c0153054
<0> 00000000 00000000 00000000 00000000 00000020 f65853c0 c01530f0 00000000
<0> f65853c0 f7e08bcc 00000000 f7cd3931 f6437f40 f6f64148 f6585440 f65853c0
<0>Call Trace:
<0> [<c0152fe0>] __read_cache_page+0x70/0xc0
<0> [<c0153054>] read_cache_page_async+0x24/0xb0
<0> [<c01530f0>] read_cache_page+0x10/0x50
<0> [<f7e08bcc>] i915_gem_object_get_page_list+0x7c/0x100 [i915]
<0> [<f7cd3931>] drm_mm_split_at_start+0x21/0x80 [drm]
<0> [<f7e09437>] i915_gem_object_bind_to_gtt+0xd7/0x1f0 [i915]
<0> [<f7e0a617>] i915_gem_object_pin+0x87/0xd0 [i915]
<0> [<f7e0a9e2>] i915_gem_init_object+0x12/0x50 [i915]
<0> [<f7ccc627>] drm_gem_object_alloc+0x87/0xb0 [drm]
<0> [<f7e0aff1>] i915_gem_init_ringbuffer+0x71/0x340 [i915]
<0> [<f7cd3887>] drm_mm_create_tail_node+0x27/0x80 [drm]
<0> [<f7e03fc7>] i915_load_modeset_init+0x2e7/0x460 [i915]
<0> [<f7e0434a>] i915_driver_load+0x1ba/0x2c0 [i915]
<0> [<f7cd085e>] drm_get_dev+0x1ce/0x200 [drm]
<0> [<c01ff5f0>] pci_get_dev_by_id+0x40/0x80
<0> [<f7ccb17c>] drm_init+0x8c/0xf0 [drm]
<0> [<f7c78000>] i915_init+0x0/0x6a [i915]
<0> [<c0101113>] do_one_initcall+0x23/0x1d0
<0> [<c01ee015>] idr_get_empty_slot+0xc5/0x150
<0> [<c01b19d2>] sysfs_add_one+0x12/0x50
<0> [<c01ee74f>] ida_get_new_above+0x3f/0x1b0
<0> [<c01b1880>] sysfs_ilookup_test+0x0/0x10
<0> [<c01b1880>] sysfs_ilookup_test+0x0/0x10
<0> [<c0183de1>] ifind+0x31/0xa0
<0> [<c01b1987>] __sysfs_add_one+0x47/0x80
<0> [<c01b19d2>] sysfs_add_one+0x12/0x50
<0> [<c01b18cf>] sysfs_addrm_start+0x3f/0xb0
<0> [<c01b1b5e>] sysfs_addrm_finish+0xe/0xa0
<0> [<c016a7bd>] __vunmap+0x4d/0xc0
<0> [<c014a8c4>] load_module+0xa14/0xb70
<0> [<c0152bb0>] filemap_fault+0x0/0x360
<0> [<c013f277>] blocking_notifier_call_chain+0x17/0x20
<0> [<c014ab06>] sys_init_module+0xe6/0x1a0
<0> [<c010340a>] syscall_call+0x7/0xb
<0>Code:  Bad EIP value.
<0>EIP: [<00000000>] 0x0 SS:ESP 0068:f648bca8
<4>---[ end trace 6e26e53289db93ad ]---

