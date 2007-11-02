Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbXKBXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbXKBXRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbXKBXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:17:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52482 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXKBXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:17:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472BAFDF.9000301@s5r6.in-berlin.de>
Date: Sat, 03 Nov 2007 00:16:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to
 boot: kernel BUG at include/linux/scatterlist.h:49!
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> <472BA567.8040301@s5r6.in-berlin.de>
In-Reply-To: <472BA567.8040301@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Torsten Kaiser wrote:
>> Both 2.6.24-rc1 and the current git version fail to boot for me:
>>
>> [   57.182205] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16] MMIO=[effff800-efffffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
>> [   57.194032] eth1394: eth2: IPv4 over IEEE 1394 (fw-host0)
>> [   57.199527] ------------[ cut here ]------------
>> [   57.204154] kernel BUG at include/linux/scatterlist.h:49!
>> [   57.209559] invalid opcode: 0000 [1] SMP
>> [   57.213667] CPU 0
>> [   57.215742] Modules linked in:
>> [   57.218857] Pid: 1, comm: swapper Not tainted 2.6.24-rc1 #1
>> [   57.224435] RIP: 0010:[<ffffffff80463512>]  [<ffffffff80463512>] dma_region_alloc+0x142/0x180
>> [   57.233003] RSP: 0000:ffff810004f29db0  EFLAGS: 00010293
>> [   57.238322] RAX: ffffc20001454000 RBX: 0000000000000000 RCX: ffffe20001c7e690
>> [   57.245457] RDX: 0000000000000000 RSI: 00003ffffffff000 RDI: 0000000000000388
>> [   57.252592] RBP: ffff810005ddca48 R08: 0000000000000000 R09: ffffc20001454000
>> [   57.259727] R10: 0000000000000002 R11: 0000000000000000 R12: 0000000087654321
>> [   57.266862] R13: ffff810100914000 R14: 0000000000000002 R15: ffff810005e88000
>> [   57.273996] FS:  0000000000000000(0000) GS:ffffffff8079c000(0000) knlGS:0000000000000000
>> [   57.282082] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> [   57.287834] CR2: 0000000000e01766 CR3: 0000000000201000 CR4: 00000000000006e0
>> [   57.294968] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   57.302102] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   57.309238] Process swapper (pid: 1, threadinfo ffff810004f28000, task ffff81010032a000)
>> [   57.317332] Stack:  ffff810005ddca48 0000000000000002 ffff810005ddca00 0000000000000010
>> [   57.325546]  000000000000001f ffffffff80464146 ffffffff8089ff00 0000000000010000
>> [   57.333104]  ffff810005ddca00 ffff8101011b66c0 ffff810005e88000 ffffffff80754740
>> [   57.340455] Call Trace:
>> [   57.343139]  [<ffffffff80464146>] hpsb_iso_common_init+0x1e6/0x210
>> [   57.349322]  [<ffffffff80464198>] hpsb_iso_recv_init+0x28/0x70
>> [   57.355159]  [<ffffffff8046c940>] ether1394_iso+0x0/0x130
>> [   57.360564]  [<ffffffff8046bc08>] ether1394_recv_init+0x58/0xd0
[...]
>> from gdb:
>> 0xffffffff80463512 is in dma_region_alloc (include/linux/scatterlist.h:49).
>> 44               * In order for the low bit stealing approach to work, pages
>> 45               * must be aligned at a 32-bit boundary as a minimum.
>> 46               */
>> 47              BUG_ON((unsigned long) page & 0x03);
>> 48      #ifdef CONFIG_DEBUG_SG
>> 49              BUG_ON(sg->sg_magic != SG_MAGIC);
>> 50      #endif
>> 51              sg->page_link = page_link | (unsigned long) page;
>> 52      }
>> 53
> 
> Uh oh...
> 
> I'm afraid the ieee1394 core's own scatter-gather list managing code
> didn't survive the changes in the kernel's s/g list implementation.
> 
> Alas I will be quite busy with non-Linux related stuff during at least
> the next two weeks and can't fix this myself for now.

Jens, maybe you can come up with a fix quicker than I could.
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
