Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbYF3LbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbYF3LbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 07:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYF3LbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 07:31:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10351 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbYF3LbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 07:31:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fMazLAzH7Xw92cKSIxh4KusaoZu7tQ2JDb9A2pQAY7carFsboueDX+zA8RFeuQSSy+
         yD06yUpm7CNcqOqc1HV1OKaTjNNq1KEwF0YfScJRrmVp2Wt3/7vb5D9V9PnyE4LMuTEe
         c6elANQE6CUj/nJXRDOZCuVwhr+5DJhlDaruw=
Message-ID: <c4e36d110806300430m157479f6pa6cdbf456df0934e@mail.gmail.com>
Date: Mon, 30 Jun 2008 13:30:57 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       riel@redhat.com
In-Reply-To: <c4e36d110806130715v4126d9b6vef69746e3b4e493b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <200806131608.31803.rjw@sisk.pl>
	 <c4e36d110806130715v4126d9b6vef69746e3b4e493b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2008/6/13 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Thursday, 12 of June 2008, Zdenek Kabelac wrote:
>>> Hello
>>>
>>> I'm attaching a trace where my machine has got into big troubles after
>>> 2 day usage and several successful suspend/resumes (this seems to be
>>> finally getting better now :))
>>>
>>> It looks like while there was a huge amount of buffers and caches -
>>> system was unable to allocate few pages for kmalloc in iwl3945 driver
>>> after resume.
>>>
>>> I've even tried to 3 > drop_cache  and reinsert iwl driver - but this
>>> had fatal results - machine died completely with blinking caps lock -
>>> and no oops in the log for this case:
>>>
>>> This is the commit aab2545fdd6641b76af0ae96456c4ca9d1e50dad  for the
>>> 2.6.26-rc5 I've been in this case.
>>
>> Is this a regression from 2.6.25, BTW?
>
> Well I've never seen this with 2.6.25 kernel - on the other hand
> usually I've not been running machine for a longer period of time,
> because suspend was failing too often I guess. Now it's more stable so
> this bug has shown up.
>
> It might be related to this issue as well http://lkml.org/lkml/2008/5/22/308
>


I'd like to point out - that -rc8 kernel without the iwl patch from
this thread is still failing (even though the OOM patch for memory
allocation on x86_64 is in the /mm directory.

Also as far as I can see - there is actually DMA memory chunk to
satisfy order 5 allocation in the log - so why is it failing ?

Zdenek

----

ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
NetworkManager: page allocation failure. order:5, mode:0x24
Pid: 2656, comm: NetworkManager Tainted: G        W 2.6.26-rc8 #37

Call Trace:
 [<ffffffff81092de0>] __alloc_pages_internal+0x460/0x5a0
 [<ffffffffa0228818>] ? :iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
 [<ffffffff81092f3b>] __alloc_pages+0xb/0x10
 [<ffffffff81011c86>] dma_alloc_pages+0x26/0x30
 [<ffffffff81011d74>] dma_alloc_coherent+0xe4/0x2d0
 [<ffffffffa02273d3>] :iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
 [<ffffffffa022a08e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
 [<ffffffffa021de01>] :iwl3945:__iwl3945_up+0x91/0x640
 [<ffffffffa021e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
 [<ffffffff8128b30d>] ? __nla_put+0x2d/0x40
 [<ffffffff8128b2c3>] ? __nla_reserve+0x53/0x70
 [<ffffffff810b3714>] ? deactivate_slab+0x194/0x1c0
 [<ffffffffa0184dff>] :mac80211:ieee80211_open+0x13f/0x590
 [<ffffffff81274738>] ? dev_set_rx_mode+0x48/0x60
 [<ffffffff81276809>] dev_open+0x89/0xf0
 [<ffffffff81276031>] dev_change_flags+0xa1/0x1e0
 [<ffffffff81273ca9>] ? dev_get_by_index+0x19/0x80
 [<ffffffff8127f214>] do_setlink+0x214/0x3a0
 [<ffffffff812f6c20>] ? _read_unlock+0x30/0x60
 [<ffffffff8127f4ad>] rtnl_setlink+0x10d/0x150
 [<ffffffff8128069d>] rtnetlink_rcv_msg+0x18d/0x240
 [<ffffffff81280510>] ? rtnetlink_rcv_msg+0x0/0x240
 [<ffffffff8128b079>] netlink_rcv_skb+0x89/0xb0
 [<ffffffff812804f9>] rtnetlink_rcv+0x29/0x40
 [<ffffffff8128aa95>] netlink_unicast+0x2d5/0x2f0
 [<ffffffff8126ef7e>] ? __alloc_skb+0x6e/0x150
 [<ffffffff8128acb4>] netlink_sendmsg+0x204/0x300
 [<ffffffff812f6c20>] ? _read_unlock+0x30/0x60
 [<ffffffff81266887>] sock_sendmsg+0x127/0x140
 [<ffffffff812666e9>] ? sock_recvmsg+0x139/0x150
 [<ffffffff81052a90>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81267627>] ? move_addr_to_kernel+0x57/0x60
 [<ffffffff8126ff8c>] ? verify_iovec+0x3c/0xd0
 [<ffffffff81266a29>] sys_sendmsg+0x189/0x320
 [<ffffffff8126772d>] ? sys_sendto+0xfd/0x120
 [<ffffffff810ce6ac>] ? d_free+0x6c/0x80
 [<ffffffff810bb2dd>] ? __fput+0x17d/0x1f0
 [<ffffffff812f66b9>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80

Mem-info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
Active:276891 inactive:134614 dirty:27 writeback:0 unstable:0
 free:4046 slab:46992 mapped:20984 pagetables:6432 bounce:0
DMA free:7896kB min:40kB low:48kB high:60kB active:3728kB
inactive:956kB present:15176kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1959 1959 1959
DMA32 free:8288kB min:5640kB low:7048kB high:8460kB active:1103836kB
inactive:537500kB present:2006684kB pages_scanned:0 all_unreclaimable?
no
lowmem_reserve[]: 0 0 0 0
DMA: 116*4kB 156*8kB 159*16kB 0*32kB 1*64kB 0*128kB 0*256kB 1*512kB
1*1024kB 1*2048kB 0*4096kB = 7904kB
DMA32: 1342*4kB 182*8kB 14*16kB 21*32kB 6*64kB 0*128kB 1*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 8360kB
223498 total pagecache pages
Swap cache: add 1441, delete 1373, find 22/33
Free swap  = 1014760kB
Total swap = 1020088kB
517808 pages of RAM
17370 reserved pages
248201 pages shared
68 pages swap cached
iwl3945: Tx 5 queue init failed
iwl3945: Unable to int nic
ACPI: PCI interrupt for device 0000:03:00.0 disabled
