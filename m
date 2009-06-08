Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZFHM3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZFHM3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZFHM3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:29:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:52382 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbZFHM3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:29:25 -0400
X-SpamScore: -37
X-BigFish: VPS-37(z21eWz1432R98dR1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKX6OT-03-FQB-01
Date: Mon, 8 Jun 2009 14:29:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] dma-debug updates for 2.6.31
Message-ID: <20090608122917.GA4073@amd.com>
References: <20090603082654.GA22359@amd.com> <20090607093758.GD31286@elte.hu> <20090607101454.GA15331@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090607101454.GA15331@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Jun 2009 12:29:18.0163 (UTC) FILETIME=[BE130230:01C9E834]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 12:14:54PM +0200, Ingo Molnar wrote:
> 
> note, i'm getting this warning:
> 
> [   17.505263] ttyS0: 1 input overrun(s)
> [   18.537568] ------------[ cut here ]------------
> [   18.539366] WARNING: at lib/dma-debug.c:812 check_unmap+0x395/0x5e6()
> [   18.539366] Hardware name: System Product Name
> [   18.539366] forcedeth 0000:00:0a.0: DMA-API: device driver frees DMA memory with wrong function [device address=0x000000003b95296a] [size=90 bytes] [mapped as single] [unmapped as page]
> [   18.539366] Pid: 4316, comm: ifup-eth Not tainted 2.6.30-rc8-tip-01994-g0c51e15-dirty #50306
> [   18.539366] Call Trace:
> [   18.539366]  <IRQ>  [<ffffffff8146c4cc>] ? check_unmap+0x395/0x5e6
> [   18.539366]  [<ffffffff8105ac13>] warn_slowpath_common+0x83/0xc6
> [   18.539366]  [<ffffffff8105acd9>] warn_slowpath_fmt+0x4b/0x61
> [   18.539366]  [<ffffffff8146c234>] ? check_unmap+0xfd/0x5e6
> [   18.539366]  [<ffffffff8146c4cc>] check_unmap+0x395/0x5e6
> [   18.539366]  [<ffffffff8146c99f>] debug_dma_unmap_page+0x5e/0x74
> [   18.539366]  [<ffffffff816b1984>] nv_tx_done_optimized+0xb2/0x28a
> [   18.539366]  [<ffffffff81c9a5d2>] ? _spin_lock_irqsave+0x65/0x85
> [   18.539366]  [<ffffffff816b5aa1>] nv_napi_poll+0x28b/0x2ca
> [   18.539366]  [<ffffffff81a91d03>] net_rx_action+0xbd/0x22b
> [   18.539366]  [<ffffffff81a91e0b>] ? net_rx_action+0x1c5/0x22b
> [   18.539366]  [<ffffffff810a5015>] ? __rcu_process_callbacks+0x163/0x216
> [   18.539366]  [<ffffffff8106147b>] __do_softirq+0x85/0x136
> [   18.539366]  [<ffffffff81058362>] ? copy_signal+0x6b/0x39f
> [   18.539366]  [<ffffffff8101536c>] call_softirq+0x1c/0x30
> [   18.539366]  [<ffffffff8101752d>] do_softirq+0x51/0xae
> [   18.539366]  [<ffffffff81081a6d>] ? tick_handle_periodic+0x30/0x97
> [   18.539366]  [<ffffffff81061081>] irq_exit+0x52/0xaf
> [   18.539366]  [<ffffffff81030fff>] smp_apic_timer_interrupt+0x9b/0xc1
> [   18.539366]  [<ffffffff81014d53>] apic_timer_interrupt+0x13/0x20
> [   18.539366]  <EOI>  [<ffffffff810e5ac4>] ? kmem_cache_alloc+0x8b/0xcb
> [   18.539366]  [<ffffffff81058362>] ? copy_signal+0x6b/0x39f
> [   18.539366]  [<ffffffff811130eb>] ? copy_fs_struct+0xaf/0xd1
> [   18.539366]  [<ffffffff810597f2>] ? copy_process+0x580/0xd99
> [   18.539366]  [<ffffffff8105a174>] ? do_fork+0x169/0x33a
> [   18.539366]  [<ffffffff81457c69>] ? __up_read+0x8f/0xb0
> [   18.539366]  [<ffffffff81078f3a>] ? up_read+0x35/0x50
> [   18.539366]  [<ffffffff810af5bc>] ? perf_swcounter_event+0x30/0x46
> [   18.539366]  [<ffffffff8101264d>] ? sys_clone+0x37/0x52
> [   18.539366]  [<ffffffff810144f3>] ? stub_clone+0x13/0x20
> [   18.539366]  [<ffffffff81014182>] ? system_call_fastpath+0x16/0x1b
> [   18.539366] ---[ end trace 1d4adcfbc3df3215 ]---
> [   18.539366] Mapped at:
> [   18.539366]  [<ffffffff8146ceb0>] debug_dma_map_page+0x8b/0x1b9
> [   18.539366]  [<ffffffff816b0eb0>] nv_start_xmit_optimized+0x2a2/0x6c5
> [   18.539366]  [<ffffffff81a9503b>] dev_hard_start_xmit+0xd9/0x163
> [   18.539366]  [<ffffffff81ab0a12>] __qdisc_run+0xfc/0x223
> [   18.539366]  [<ffffffff81a95483>] dev_queue_xmit+0x284/0x3d4
> [   18.544082] ttyS0: 2 input overrun(s)
> [   18.639248] eth1: link down

This warning is not uncommon for the forcedeth driver. I got them
several times during testing. Havn't you got this warning with earlier
versions of dma-debug on this machine?

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

