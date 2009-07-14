Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZGNA4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZGNA4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZGNA4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:56:38 -0400
Received: from pop-tawny.atl.sa.earthlink.net ([207.69.195.67]:33166 "EHLO
	pop-tawny.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbZGNA4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:56:37 -0400
Message-ID: <4A5BD7B5.1010904@earthlink.net>
Date: Mon, 13 Jul 2009 20:56:21 -0400
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15 (Ubuntu-1.1.15+nobinonly-0ubuntu2)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org, tony.luck@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
References: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1247466360-13330-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This is the second version of the patchset to convert SPARC to
> asm-generic/dma-mapping-common.h and pci-dma-compat.h:
>
>   
I still get the same runtime warning with this patch set at boot time.

The bad address is within the kernel so it looks like
it's catching a real bug.

cat kallsyms | grep f0007000
f0007000 T trapbase_cpu3

WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
rodata [addr=f0007000] [len=4096]
Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 
scsi_mod
[f011ffa0 : check_for_illegal_area+0xc8/0x100 ]
[f0120b1c : debug_dma_map_sg+0x158/0x1c4 ]
[fe6946d0 : sbus_esp_map_sg+0xec/0xfc [sun_esp] ]
[fe684454 : esp_maybe_execute_command+0x1f0/0x6f8 [esp_scsi] ]
[fe6849e4 : esp_queuecommand+0x88/0x98 [esp_scsi] ]
[fe638c00 : scsi_dispatch_cmd+0x200/0x2a8 [scsi_mod] ]
[fe63f038 : scsi_request_fn+0x3f4/0x52c [scsi_mod] ]
[f00f6d64 : __generic_unplug_device+0x40/0x50 ]
[f00f6d90 : generic_unplug_device+0x1c/0x38 ]
[f00f4be4 : blk_unplug+0x14/0x24 ]
[f00ade1c : sync_buffer+0x48/0x60 ]
[f01f6d58 : __wait_on_bit+0x4c/0xa4 ]
[f01f6e60 : out_of_line_wait_on_bit+0xb0/0xc0 ]
[fe709320 : __ext3_get_inode_loc+0x3bc/0x418 [ext3] ]
[fe7093b4 : ext3_iget+0x38/0x65c [ext3] ]
[fe712c70 : ext3_get_journal+0xc/0xd4 [ext3] ]

