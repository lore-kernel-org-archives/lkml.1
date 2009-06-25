Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZFYBWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZFYBWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFYBWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:22:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45986 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZFYBWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:22:12 -0400
Date: Wed, 24 Jun 2009 20:34:51 -0400
From: Dave Jones <davej@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: More odd kmemleak traces.
Message-ID: <20090625003451.GA23387@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see a bunch of kmemleak traces on one of my machines.
These traces all seem to be early allocations during boot up,
and I don't see anything obvious from the traces to figure out what
we're leaking.  False positives?

Lots of these...

kmemleak: unreferenced object 0xdb9fde70 (size 40):
kmemleak:   comm "swapper", pid 1, jiffies 4294668061
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c066c901>] acpi_ut_allocate_object_desc_dbg+0x46/0x89
kmemleak:     [<c066c975>] acpi_ut_create_internal_object_dbg+0x31/0x9c
kmemleak:     [<c065441c>] acpi_ds_build_internal_object+0xfc/0x150
kmemleak:     [<c0654699>] acpi_ds_build_internal_package_obj+0xf4/0x19b
kmemleak:     [<c0652cbd>] acpi_ds_eval_data_object_operands+0xbb/0xfb
kmemleak:     [<c0653928>] acpi_ds_exec_end_op+0x246/0x37e
kmemleak:     [<c0665fa5>] acpi_ps_parse_loop+0x5e5/0x740
kmemleak:     [<c066532f>] acpi_ps_parse_aml+0x9a/0x2a5
kmemleak:     [<c065325a>] acpi_ds_execute_arguments+0x102/0x134
kmemleak:     [<c0653346>] acpi_ds_get_package_arguments+0x51/0x65
kmemleak:     [<c0663920>] acpi_ns_init_one_object+0xbb/0x10b
kmemleak:     [<c0663ed7>] acpi_ns_walk_namespace+0xbd/0x133
kmemleak:     [<c0661c8e>] acpi_walk_namespace+0x74/0xaf
kmemleak:     [<c0663831>] acpi_ns_initialize_objects+0x36/0x6a

And a few of these in pnp..

kmemleak: unreferenced object 0xd9d0db40 (size 16):
kmemleak:   comm "swapper", pid 1, jiffies 4294674288
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5c89>] kmem_cache_alloc_notrace+0x121/0x13d
kmemleak:     [<c067b9da>] reserve_range+0x4a/0x177
kmemleak:     [<c067bba5>] system_pnp_probe+0x9e/0xcd
kmemleak:     [<c0676c30>] pnp_device_probe+0x91/0xc1
kmemleak:     [<c06b7f24>] driver_probe_device+0xca/0x1d9
kmemleak:     [<c06b8089>] __driver_attach+0x56/0x84
kmemleak:     [<c06b7350>] bus_for_each_dev+0x53/0x8e
kmemleak:     [<c06b7ca1>] driver_attach+0x27/0x3a
kmemleak:     [<c06b793b>] bus_add_driver+0xde/0x233
kmemleak:     [<c06b83d8>] driver_register+0x89/0xfe
kmemleak:     [<c067698f>] pnp_register_driver+0x2b/0x3e
kmemleak:     [<c0ab6985>] pnp_system_init+0x1b/0x2e
kmemleak:     [<c040309e>] do_one_initcall+0x75/0x193
kmemleak:     [<c0a86525>] kernel_init+0x1af/0x211
kmemleak:     [<c040b5df>] kernel_thread_helper+0x7/0x10
kmemleak: unreferenced object 0xd9d8c9a0 (size 64):
kmemleak:   comm "swapper", pid 1, jiffies 4294674288
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5c89>] kmem_cache_alloc_notrace+0x121/0x13d
kmemleak:     [<c0453d29>] __request_region+0x49/0x175
kmemleak:     [<c067ba8c>] reserve_range+0xfc/0x177
kmemleak:     [<c067bba5>] system_pnp_probe+0x9e/0xcd
kmemleak:     [<c0676c30>] pnp_device_probe+0x91/0xc1
kmemleak:     [<c06b7f24>] driver_probe_device+0xca/0x1d9
kmemleak:     [<c06b8089>] __driver_attach+0x56/0x84
kmemleak:     [<c06b7350>] bus_for_each_dev+0x53/0x8e
kmemleak:     [<c06b7ca1>] driver_attach+0x27/0x3a
kmemleak:     [<c06b793b>] bus_add_driver+0xde/0x233
kmemleak:     [<c06b83d8>] driver_register+0x89/0xfe
kmemleak:     [<c067698f>] pnp_register_driver+0x2b/0x3e
kmemleak:     [<c0ab6985>] pnp_system_init+0x1b/0x2e
kmemleak:     [<c040309e>] do_one_initcall+0x75/0x193
kmemleak:     [<c0a86525>] kernel_init+0x1af/0x211

and lots of the one I already reported ..

kmemleak: unreferenced object 0xdb804080 (size 20):
kmemleak:   comm "swapper", pid 0, jiffies 4294667296
kmemleak:   backtrace:
kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
kmemleak:     [<ffffffff>] 0xffffffff


	Dave

