Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZAGWkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZAGWkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbZAGWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:39:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:55166 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbZAGWil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:38:41 -0500
Message-ID: <49652ED1.6050808@kernel.org>
Date: Wed, 07 Jan 2009 14:38:09 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: initrd panic
References: <86802c440901071357j3dd03b2ax9b79735fd374e94d@mail.gmail.com> <20090107215914.GB17917@elte.hu>
In-Reply-To: <20090107215914.GB17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> [    0.000000] Bootmem setup node 0 0000000000000000-0000000828000000
>> [    0.000000]   NODE_DATA [000000000008b580 - 000000000009057f]
>> [    0.000000]   bootmap [00000000011e4000 -  00000000012e8fff] pages 105
>> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0828000000]
>> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
>> [0000000000 - 0000001000]
>> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
>> [0000006000 - 0000008000]
>> [    0.000000]   #2 [0000200000 - 00011e3010]    TEXT DATA BSS ==>
>> [0000200000 - 00011e3010]
>> [    0.000000]   #3 [007ddb0000 - 007ffff746]          RAMDISK ==>
>> [007ddb0000 - 007ffff746]
>> [    0.000000]   #4 [0000095400 - 0000100000]    BIOS reserved ==>
>> [0000095400 - 0000100000]
>> [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==>
>> [0000008000 - 000000a000]
>> [    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE ==>
>> [000000a000 - 000000b000]
>> [    0.000000]   #7 [0000001000 - 000000106c]        ACPI SLIT ==>
>> [0000001000 - 000000106c]
>> [    0.000000]   #8 [000000b000 - 000008b580]       MEMNODEMAP ==>
>> [000000b000 - 000008b580]
>> ...
>> [   26.878476] calling  populate_rootfs+0x0/0xef @ 1
>> [   26.883266] checking if image is initramfs...it isn't (no cpio
>> magic); looks like an initrd
>> [   26.925007] Freeing initrd memory: 35133k freed
>> [   26.947946] initcall populate_rootfs+0x0/0xef returned 0 after 63247 usecs
>> ...
>> [   99.714363] RAMDISK: gzip image found at block 0
>> [  100.831449] RAMDISK: incomplete write (1880 != 1999)
>> [  100.836421] write error
>> [  101.092202] kjournald starting.  Commit interval 5 seconds
>> [  101.092217] EXT3 FS on ram0, internal journal
>> [  101.092227] EXT3-fs: mounted filesystem with ordered data mode.
>> [  101.092244] VFS: Mounted root (ext3 filesystem) on device 1:0.
>> [  101.092262] Freeing unused kernel memory: 448k freed
>> [  101.092586] init_special_inode: bogus i_mode (177777)
>> [  101.092591] Warning: unable to open an initial console.
>> [  101.092607] init_special_inode: bogus i_mode (177777)
>> [  101.092618] init_special_inode: bogus i_mode (177777)
>> [  101.092630] init_special_inode: bogus i_mode (177777)
>> [  101.092635] Kernel panic - not syncing: No init found.  Try passing
>> init= option to kernel.
>> [  101.092639] Pid: 1, comm: swapper Not tainted
>> 2.6.28-tip-07660-g1bc0566-dirty #366
>> [  101.092641] Call Trace:
>> [  101.092655]  [<ffffffff809cc9be>] panic+0x75/0x12c
>> [  101.092662]  [<ffffffff802092a8>] name_to_dev_t+0x0/0x1f0
>> [  101.092668]  [<ffffffff8022c05a>] ? child_rip+0xa/0x20
>> [  101.092671]  [<ffffffff8022c050>] ? child_rip+0x0/0x20
>>
>>
>> wonder if LZMA B2ZIP etc into tip/master today broke it?
> 
> you enabled:
> 
>  CONFIG_KERNEL_LZMA=y
>  CONFIG_RD_LZMA=y
no
> 
> ? Or did the normal zlib decompressor break?
looks like

YH
