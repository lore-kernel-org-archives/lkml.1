Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZGNBlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZGNBlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZGNBlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:41:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:45226 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZGNBli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:41:38 -0400
Date: Tue, 14 Jul 2009 10:40:16 +0900
To: reif@earthlink.net, joerg.roedel@amd.com, mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A5BD7B5.1010904@earthlink.net>
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4A5BD7B5.1010904@earthlink.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090714103941B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Jul 2009 10:40:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 20:56:21 -0400
Robert Reif <reif@earthlink.net> wrote:

> FUJITA Tomonori wrote:
> > This is the second version of the patchset to convert SPARC to
> > asm-generic/dma-mapping-common.h and pci-dma-compat.h:
> >
> >   
> I still get the same runtime warning with this patch set at boot time.
> 
> The bad address is within the kernel so it looks like
> it's catching a real bug.
> 
> cat kallsyms | grep f0007000
> f0007000 T trapbase_cpu3
> 
> WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
> esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
> rodata [addr=f0007000] [len=4096]
> Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 

Ok, I looked at check_for_illegal_area() in dma-debug.

What check_for_illegal_area() does looks bogus to me with some of I/O
remapping hardware.


> scsi_mod
> [f011ffa0 : check_for_illegal_area+0xc8/0x100 ]
> [f0120b1c : debug_dma_map_sg+0x158/0x1c4 ]
> [fe6946d0 : sbus_esp_map_sg+0xec/0xfc [sun_esp] ]
> [fe684454 : esp_maybe_execute_command+0x1f0/0x6f8 [esp_scsi] ]
> [fe6849e4 : esp_queuecommand+0x88/0x98 [esp_scsi] ]
> [fe638c00 : scsi_dispatch_cmd+0x200/0x2a8 [scsi_mod] ]
> [fe63f038 : scsi_request_fn+0x3f4/0x52c [scsi_mod] ]
> [f00f6d64 : __generic_unplug_device+0x40/0x50 ]
> [f00f6d90 : generic_unplug_device+0x1c/0x38 ]
> [f00f4be4 : blk_unplug+0x14/0x24 ]
> [f00ade1c : sync_buffer+0x48/0x60 ]
> [f01f6d58 : __wait_on_bit+0x4c/0xa4 ]
> [f01f6e60 : out_of_line_wait_on_bit+0xb0/0xc0 ]
> [fe709320 : __ext3_get_inode_loc+0x3bc/0x418 [ext3] ]
> [fe7093b4 : ext3_iget+0x38/0x65c [ext3] ]
> [fe712c70 : ext3_get_journal+0xc/0xd4 [ext3] ]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
