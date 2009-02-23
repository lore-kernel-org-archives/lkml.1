Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBWJkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBWJkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZBWJkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:40:43 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:41599 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZBWJkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AAlUA4fakl0NCSOA7Lg9JlVZvzDdQwBXL9lxpkUwD0EJAVbZyEtKLIveMHHFrq20oG
         8QWNRhnleyiZaGlvKaPIaKzJkg3ch2dv7RIeLK7P+d8oas90WdklJedW/mOHoUE2oITE
         uQpG7E8y08d+wL4ewPM4ypcmR3qwqEwj824fA=
MIME-Version: 1.0
In-Reply-To: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
References: <200902230824.n1N8OV3P015018@www262.sakura.ne.jp>
Date: Mon, 23 Feb 2009 11:40:38 +0200
X-Google-Sender-Auth: e196b7f2e915aaaa
Message-ID: <84144f020902230140v83e153cr3a0c8195aab1b835@mail.gmail.com>
Subject: Re: How to analyze kmemleak message?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm cc'ing Catalin.)

On Mon, Feb 23, 2009 at 10:24 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> I got this message with linux-2.6.29-rc5-next-20090220 .
>
> [   89.856902] unreferenced object 0xf7009180 (size 124):
> [   89.857484]   comm "swapper", pid 0, jiffies 4294892306
> [   89.857484]   backtrace:
> [   89.857484]     [<c0230695>] create_object+0x155/0x2c0
> [   89.857484]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   89.857484]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> [   89.857484]     [<c025dc23>] alloc_vfsmnt+0x23/0x170
> [   89.857484]     [<c023b632>] vfs_kern_mount+0x52/0x230
> [   89.857484]     [<c023ba2a>] kern_mount_data+0x1a/0x20
> [   89.857484]     [<c126a03e>] bdev_cache_init+0x6e/0xd0
> [   89.857484]     [<c1268ce7>] vfs_caches_init+0x77/0x90
> [   89.857484]     [<c1237e8d>] start_kernel+0x25d/0x380
> [   89.857484]     [<c1237092>] __init_begin+0x92/0xe0
> [   89.857484]     [<ffffffff>] 0xffffffff
> [   89.886404] unreferenced object 0xf700d0e0 (size 8):
> [   89.888384]   comm "swapper", pid 0, jiffies 4294892306
> [   89.890117]   backtrace:
> [   89.890393]     [<c0230695>] create_object+0x155/0x2c0
> [   89.890393]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   89.890393]     [<c022bb44>] __kmalloc_track_caller+0x234/0x2d0
> [   89.890393]     [<c0200a95>] kstrdup+0x55/0xa0
> [   89.890393]     [<c025dcf1>] alloc_vfsmnt+0xf1/0x170
> [   89.890393]     [<c023b632>] vfs_kern_mount+0x52/0x230
> [   89.890393]     [<c023ba2a>] kern_mount_data+0x1a/0x20
> [   89.890393]     [<c126a03e>] bdev_cache_init+0x6e/0xd0
> [   89.890393]     [<c1268ce7>] vfs_caches_init+0x77/0x90
> [   89.890393]     [<c1237e8d>] start_kernel+0x25d/0x380
> [   89.890393]     [<c1237092>] __init_begin+0x92/0xe0
> [   89.890393]     [<ffffffff>] 0xffffffff
> [   89.926356] unreferenced object 0xf60f6080 (size 16):
> [   89.929082]   comm "swapper", pid 1, jiffies 4294897223
> [   89.929480]   backtrace:
> [   89.929480]     [<c0230695>] create_object+0x155/0x2c0
> [   89.929480]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   89.929480]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> [   89.929480]     [<c03c9ecd>] reserve_range+0x52d/0x630
> [   89.929480]     [<c03ca103>] reserve_resources_of_dev+0x133/0x150
> [   89.929480]     [<c03ca12d>] system_pnp_probe+0xd/0x30
> [   89.929480]     [<c03bb52d>] pnp_device_probe+0xed/0x1c0
> [   89.929480]     [<c040d798>] really_probe+0x358/0x490
> [   89.929480]     [<c040dada>] driver_probe_device+0xaa/0x150
> [   89.929480]     [<c040dd69>] __driver_attach+0xb9/0x110
> [   89.929480]     [<c040acf5>] bus_for_each_dev+0x65/0x90
> [   89.929480]     [<c040ddde>] driver_attach+0x1e/0x30
> [   89.929480]     [<c040baa2>] bus_add_driver+0x1a2/0x830
> [   89.929480]     [<c040e568>] driver_register+0xc8/0x180
> [   89.929480]     [<c03bb97c>] pnp_register_driver+0x1c/0x20
> [   89.929480]     [<c1274c4d>] pnp_system_init+0xd/0x10
> [   89.978981] unreferenced object 0xf65205a0 (size 32):
> [   89.981599]   comm "swapper", pid 1, jiffies 4294897223
> [   89.982969]   backtrace:
> [   89.982969]     [<c0230695>] create_object+0x155/0x2c0
> [   89.982969]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   89.982969]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> [   89.982969]     [<c016e29d>] __request_region+0x4cd/0x5d0
> [   89.982969]     [<c03c9a6e>] reserve_range+0xce/0x630
> [   89.982969]     [<c03ca103>] reserve_resources_of_dev+0x133/0x150
> [   89.982969]     [<c03ca12d>] system_pnp_probe+0xd/0x30
> [   89.982969]     [<c03bb52d>] pnp_device_probe+0xed/0x1c0
> [   89.982969]     [<c040d798>] really_probe+0x358/0x490
> [   89.982969]     [<c040dada>] driver_probe_device+0xaa/0x150
> [   89.982969]     [<c040dd69>] __driver_attach+0xb9/0x110
> [   89.982969]     [<c040acf5>] bus_for_each_dev+0x65/0x90
> [   89.982969]     [<c040ddde>] driver_attach+0x1e/0x30
> [   89.982969]     [<c040baa2>] bus_add_driver+0x1a2/0x830
> [   89.982969]     [<c040e568>] driver_register+0xc8/0x180
> [   89.982969]     [<c03bb97c>] pnp_register_driver+0x1c/0x20
> [   90.037062] unreferenced object 0xf6189ee0 (size 8):
> [   90.038484]   comm "swapper", pid 1, jiffies 4294898432
> [   90.038484]   backtrace:
> [   90.038484]     [<c0230695>] create_object+0x155/0x2c0
> [   90.038484]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   90.038484]     [<c022a9ea>] __kmalloc+0x22a/0x2d0
> [   90.038484]     [<c033fd06>] kvasprintf+0x36/0x80
> [   90.038484]     [<c0332b63>] kobject_set_name_vargs+0x13/0x60
> [   90.038484]     [<c0332ce1>] kobject_add_varg+0x21/0x70
> [   90.038484]     [<c0332db0>] kobject_add+0x80/0xa0
> [   90.038484]     [<c127ad05>] memmap_init+0xd5/0x160
> [   90.038484]     [<c0101147>] do_one_initcall+0x47/0x2b0
> [   90.038484]     [<c1237fda>] do_initcalls+0x2a/0x40
> [   90.038484]     [<c123800c>] do_basic_setup+0x1c/0x20
> [   90.038484]     [<c1238095>] kernel_init+0x55/0xd0
> [   90.038484]     [<c01053a7>] kernel_thread_helper+0x7/0x10
> [   90.038484]     [<ffffffff>] 0xffffffff
> (...snipped...)
> [   94.387185] unreferenced object 0xf6cbec98 (size 56):
> [   94.389132]   comm "rcS", pid 1332, jiffies 4294901842
> [   94.390892]   backtrace:
> [   94.391173]     [<c0230695>] create_object+0x155/0x2c0
> [   94.391173]     [<c0230dcb>] kmemleak_alloc+0x10b/0x1b0
> [   94.391173]     [<c0228581>] kmem_cache_alloc+0x191/0x220
> [   94.391173]     [<c02794fe>] alloc_buffer_head+0x1e/0xd0
> [   94.391173]     [<c0272b9a>] alloc_page_buffers+0x3a/0x120
> [   94.391173]     [<c0272f08>] grow_dev_page+0x168/0x2d0
> [   94.391173]     [<c0273120>] grow_buffers+0xb0/0x140
> [   94.391173]     [<c027329b>] __getblk_slow+0xeb/0x1d0
> [   94.391173]     [<c0273d22>] __getblk+0x72/0x80
> [   94.391173]     [<f895256e>] ext3_getblk+0x11e/0x3e0 [ext3]
> [   94.391173]     [<f895989a>] ext3_find_entry+0x18a/0x6e0 [ext3]
> [   94.391173]     [<f895a1dd>] ext3_lookup+0x5d/0x1c0 [ext3]
> [   94.391173]     [<c0245ece>] real_lookup+0xbe/0x230
> [   94.391173]     [<c02466af>] do_lookup+0x14f/0x240
> [   94.391173]     [<c024742c>] __link_path_walk+0xc8c/0x17e0
> [   94.391173]     [<c0247fc2>] path_walk+0x42/0xa0
>
> How to analyze kmemleak message?

The stack traces refer to the call-site that allocated an unfree'd
object that is no longer being referenced by anyone. For example, the
first stack trace claims that vfs_kern_mount() allocated a struct
vfsmount that was never free'd.
