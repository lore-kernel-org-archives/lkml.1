Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYJ2KL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYJ2KL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYJ2KLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:11:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:38552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYJ2KLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:11:48 -0400
Date: Wed, 29 Oct 2008 11:11:45 +0100
From: Nick Piggin <npiggin@suse.de>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
       aliguori@codemonkey.ws, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Message-ID: <20081029101145.GB5953@wotan.suse.de>
References: <1225234513-3996-1-git-send-email-glommer@redhat.com> <20081028232944.GA3759@wotan.suse.de> <20081029094856.GD4269@poweredge.glommer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029094856.GD4269@poweredge.glommer>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 07:48:56AM -0200, Glauber Costa wrote:

> 0xf7bfe000-0xf7c00000    8192 hpet_enable+0x2d/0x279 phys=fed00000 ioremap
> 0xf7c02000-0xf7c04000    8192 acpi_os_map_memory+0x11/0x1a phys=7fed1000 ioremap
> 0xf7c06000-0xf7c08000    8192 acpi_os_map_memory+0x11/0x1a phys=7fef2000 ioremap
> 0xf7c0a000-0xf7c0c000    8192 acpi_os_map_memory+0x11/0x1a phys=7fef2000 ioremap
> 0xf7c0d000-0xf7c0f000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf7c10000-0xf7c1f000   61440 acpi_os_map_memory+0x11/0x1a phys=7fed1000 ioremap
> 0xf7c20000-0xf7c22000    8192 acpi_os_map_memory+0x11/0x1a phys=7fef2000 ioremap
> 0xf7c24000-0xf7c27000   12288 acpi_os_map_memory+0x11/0x1a phys=7fef2000 ioremap
> 0xf7c28000-0xf7c2a000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c2c000-0xf7c2e000    8192 acpi_os_map_memory+0x11/0x1a phys=7fef4000 ioremap
> 0xf7c30000-0xf7c32000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c34000-0xf7c36000    8192 acpi_os_map_memory+0x11/0x1a phys=7fef4000 ioremap
> 0xf7c38000-0xf7c3a000    8192 acpi_os_map_memory+0x11/0x1a phys=7fed1000 ioremap
> 0xf7c3c000-0xf7c3e000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c40000-0xf7c42000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c44000-0xf7c46000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c48000-0xf7c4a000    8192 acpi_os_map_memory+0x11/0x1a phys=7fede000 ioremap
> 0xf7c4b000-0xf7c57000   49152 zisofs_init+0xd/0x1c pages=11 vmalloc
> 0xf7c58000-0xf7c5a000    8192 yenta_probe+0x123/0x63f phys=e4300000 ioremap
> 0xf7c5b000-0xf7c5e000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7c61000-0xf7c65000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf7c67000-0xf7c71000   40960 vmalloc_exec+0x12/0x14 pages=9 vmalloc
> 0xf7c72000-0xf7c74000    8192 usb_hcd_pci_probe+0x132/0x277 phys=ee404000 ioremap
> 0xf7c75000-0xf7c7c000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf7c7d000-0xf7c86000   36864 vmalloc_exec+0x12/0x14 pages=8 vmalloc
> 0xf7c87000-0xf7c89000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf7c8a000-0xf7c91000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf7c92000-0xf7c97000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7c9b000-0xf7c9f000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf7ca0000-0xf7ca5000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7ca6000-0xf7cab000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7cac000-0xf7caf000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7cb0000-0xf7cb2000    8192 iTCO_wdt_probe+0xbe/0x281 [iTCO_wdt] phys=fed1f000 ioremap
> 0xf7cb3000-0xf7cbf000   49152 vmalloc_exec+0x12/0x14 pages=11 vmalloc
> 0xf7cc0000-0xf7cce000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf7ccf000-0xf7cd2000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7cd3000-0xf7cd5000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf7cd6000-0xf7cdc000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf7cdd000-0xf7ce0000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7ce1000-0xf7ce4000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7ce6000-0xf7d02000  114688 vmalloc_exec+0x12/0x14 pages=27 vmalloc
> 0xf7d03000-0xf7d08000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7d09000-0xf7d0b000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf7d0c000-0xf7d12000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf7d13000-0xf7d24000   69632 snd_malloc_sgbuf_pages+0x190/0x1ca [snd_page_alloc] vmap
> 0xf7d25000-0xf7d2a000   20480 drm_ht_create+0x69/0xa5 [drm] pages=4 vmalloc
> 0xf7d2d000-0xf7d2f000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
> 0xf7d30000-0xf7d50000  131072 vmalloc_exec+0x12/0x14 pages=31 vmalloc
> 0xf7d51000-0xf7d54000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7d56000-0xf7d5a000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf7d5b000-0xf7d5e000   12288 vmalloc_user+0x13/0x38 pages=2 vmalloc user
> 0xf7d5f000-0xf7d67000   32768 vmalloc_exec+0x12/0x14 pages=7 vmalloc
> 0xf7d68000-0xf7d79000   69632 snd_malloc_sgbuf_pages+0x190/0x1ca [snd_page_alloc] vmap
> 0xf7d7a000-0xf7d86000   49152 vmalloc_exec+0x12/0x14 pages=11 vmalloc
> 0xf7d87000-0xf7d8e000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf7d8f000-0xf7d91000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf7d92000-0xf7d94000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
> 0xf7d96000-0xf7dba000  147456 vmalloc_exec+0x12/0x14 pages=35 vmalloc
> 0xf7dbb000-0xf7dc0000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7dc1000-0xf7dc4000   12288 vmalloc_32+0x12/0x14 pages=2 vmalloc
> 0xf7dc7000-0xf7dc9000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
> 0xf7dcb000-0xf7dd4000   36864 vmalloc_exec+0x12/0x14 pages=8 vmalloc
> 0xf7dd5000-0xf7dd7000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf7dd8000-0xf7dda000    8192 pci_iomap+0x72/0x7b phys=ee404000 ioremap
> 0xf7ddb000-0xf7dec000   69632 snd_malloc_sgbuf_pages+0x190/0x1ca [snd_page_alloc] vmap
> 0xf7ded000-0xf7e0e000  135168 vmalloc_exec+0x12/0x14 pages=32 vmalloc
> 0xf7e0f000-0xf7e23000   81920 vmalloc_exec+0x12/0x14 pages=19 vmalloc
> 0xf7e24000-0xf7e2a000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf7e2b000-0xf7e2f000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf7e30000-0xf7e34000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf7e36000-0xf7e45000   61440 vmalloc_exec+0x12/0x14 pages=14 vmalloc
> 0xf7e46000-0xf7e68000  139264 vmalloc_exec+0x12/0x14 pages=33 vmalloc
> 0xf7e6d000-0xf7e6f000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf7e70000-0xf7e79000   36864 ioremap_wc+0x21/0x23 phys=dbff8000 ioremap
> 0xf7e80000-0xf7e91000   69632 drm_addmap_core+0x16d/0x4d5 [drm] phys=ee100000 ioremap
> 0xf7e92000-0xf7ea0000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf7ea1000-0xf7ea6000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf7ec8000-0xf7ecf000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf7ed0000-0xf7f06000  221184 vmalloc_exec+0x12/0x14 pages=53 vmalloc
> 0xf7f07000-0xf7f0e000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf7f0f000-0xf7f28000  102400 vmalloc_exec+0x12/0x14 pages=24 vmalloc
> 0xf7f29000-0xf7f2f000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf7f3c000-0xf7f3e000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf7f3f000-0xf7f42000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf7f43000-0xf7f4d000   40960 vmalloc_exec+0x12/0x14 pages=9 vmalloc
> 0xf7f4e000-0xf7f50000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf7f51000-0xf7f57000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf7f59000-0xf7f67000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf7faa000-0xf7fbc000   73728 vmalloc_exec+0x12/0x14 pages=17 vmalloc
> 0xf802f000-0xf8032000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf8033000-0xf8039000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf803a000-0xf803c000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf803d000-0xf8043000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf8044000-0xf8046000    8192 __kvm_set_memory_region+0x164/0x355 [kvm] pages=1 vmalloc
> 0xf8047000-0xf8053000   49152 vmalloc_exec+0x12/0x14 pages=11 vmalloc
> 0xf8054000-0xf8058000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf8059000-0xf805b000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf805c000-0xf805e000    8192 pci_iomap+0x72/0x7b phys=edf00000 ioremap
> 0xf8062000-0xf8066000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf8069000-0xf806b000    8192 dm_vcalloc+0x24/0x4c [dm_mod] pages=1 vmalloc
> 0xf80c0000-0xf81b9000 1019904 sys_swapon+0x481/0xaa0 pages=248 vmalloc
> 0xf81e3000-0xf81e8000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf8237000-0xf823c000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf8275000-0xf827a000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf8451000-0xf845f000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf848a000-0xf848d000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf84ba000-0xf84bd000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf84be000-0xf84c2000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf84f1000-0xf84f4000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf84f5000-0xf84f8000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf8502000-0xf8510000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf8511000-0xf851f000   57344 vmalloc_exec+0x12/0x14 pages=13 vmalloc
> 0xf8523000-0xf852a000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf8534000-0xf8538000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf8539000-0xf853b000    8192 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=1 vmalloc
> 0xf853c000-0xf8545000   36864 vmalloc_exec+0x12/0x14 pages=8 vmalloc
> 0xf8546000-0xf8550000   40960 vmalloc_exec+0x12/0x14 pages=9 vmalloc
> 0xf8551000-0xf8554000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf8555000-0xf8561000   49152 vmalloc_exec+0x12/0x14 pages=11 vmalloc
> 0xf856c000-0xf856f000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf8578000-0xf857d000   20480 azx_probe+0x32b/0xa0a [snd_hda_intel] phys=ee400000 ioremap
> 0xf8594000-0xf85c1000  184320 vmalloc_exec+0x12/0x14 pages=44 vmalloc
> 0xf85db000-0xf85df000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf85f4000-0xf85f6000    8192 __kvm_set_memory_region+0x255/0x355 [kvm] pages=1 vmalloc
> 0xf85f7000-0xf85fa000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf85fb000-0xf8620000  151552 vmalloc_exec+0x12/0x14 pages=36 vmalloc
> 0xf8624000-0xf8628000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf8629000-0xf8689000  393216 vmalloc_exec+0x12/0x14 pages=95 vmalloc
> 0xf868a000-0xf8690000   24576 vmalloc_exec+0x12/0x14 pages=5 vmalloc
> 0xf8691000-0xf8695000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf8699000-0xf869c000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf86a5000-0xf86a9000   16384 vmalloc_exec+0x12/0x14 pages=3 vmalloc
> 0xf86c4000-0xf86c7000   12288 vmalloc_exec+0x12/0x14 pages=2 vmalloc
> 0xf87a6000-0xf87af000   36864 vmalloc_exec+0x12/0x14 pages=8 vmalloc
> 0xf87dd000-0xf87e2000   20480 vmalloc_exec+0x12/0x14 pages=4 vmalloc
> 0xf8815000-0xf881c000   28672 vmalloc_exec+0x12/0x14 pages=6 vmalloc
> 0xf89b8000-0xf89d2000  106496 vmalloc_exec+0x12/0x14 pages=25 vmalloc
> 0xf8a00000-0xf8a21000  135168 e1000_probe+0x1a5/0xbb3 [e1000e] phys=ee000000 ioremap
> 0xf8a22000-0xf9223000 8392704 vmalloc_32+0x12/0x14 pages=2048 vmalloc vpages
> 0xf97a4000-0xf97a7000   12288 e1000e_setup_tx_resources+0x1d/0xbf [e1000e] pages=2 vmalloc
> 0xf97a8000-0xf97ab000   12288 e1000e_setup_rx_resources+0x1d/0xfa [e1000e] pages=2 vmalloc
> 0xf97ac000-0xf98ad000 1052672 __kvm_set_memory_region+0x164/0x355 [kvm] pages=256 vmalloc
> 0xf98ae000-0xf98b1000   12288 __kvm_set_memory_region+0x1df/0x355 [kvm] pages=2 vmalloc
> 0xf98b2000-0xf98b7000   20480 __kvm_set_memory_region+0x164/0x355 [kvm] pages=4 vmalloc

Hmm, spanning <30MB of memory... how much vmalloc space do you have?

Anyway, there's quite a lot of little allocations there, and things are
getting a bit fragmented. Why don't we just drop the guard pages
completely (maybe turn them on with a debug option)? I don't think I have
ever seen a problem caught by them... not to say they can't catch problems,
but those problems could equally appear in linear KVA too (or between guard
pages).



