Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZCRL2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZCRL2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZCRL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:28:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZCRL2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:28:41 -0400
Date: Wed, 18 Mar 2009 12:28:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: e1000e 0000:04:00.0: DMA-API: device driver frees DMA memory with
	wrong function [device address=0x000000003e5a2c02]  [size=42 bytes]
	[mapped as single] [unmapped as page]
Message-ID: <20090318112810.GC32233@elte.hu>
References: <1237223130-26519-1-git-send-email-joerg.roedel@amd.com> <20090317120112.GP6159@amd.com> <20090318093847.GC5879@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318093847.GC5879@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


another -tip testbox triggered a DMA-debug warning on e1000e:

[   33.284944] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   34.129676] ------------[ cut here ]------------
[   34.132025] WARNING: at lib/dma-debug.c:562 check_unmap+0x364/0x800()
[   34.132025] Hardware name:         
[   34.132025] 
e1000e 0000:04:00.0: DMA-API: device driver frees
 DMA memory with wrong function [device address=0x000000003e5a2c02]
 [size=42 bytes] [mapped as single] [unmapped as page]
[   34.132025] Modules linked in:
[   34.132025] Pid: 1937, comm: arping Not tainted 2.6.29-rc8-tip-02728-g7db4920-dirty #2993
[   34.132025] Call Trace:
[   34.132025]  <IRQ>  [<ffffffff80281f3d>] warn_slowpath+0xfd/0x140
[   34.132025]  [<ffffffff80c12976>] ? fn_hash_lookup+0x16/0x100
[   34.132025]  [<ffffffff80bc3e65>] ? ip_route_input_slow+0x635/0x820
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff8067ef04>] check_unmap+0x364/0x800
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff8067f6d8>] debug_dma_unmap_page+0xd8/0xe0
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff807758b5>] e1000_put_txbuf+0xd5/0x170
[   34.132025]  [<ffffffff80775a53>] e1000_clean_tx_irq+0x103/0x350
[   34.132025]  [<ffffffff8077b668>] e1000_clean+0x148/0x1a0
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80b570ab>] net_rx_action+0x2bb/0x340
[   34.132025]  [<ffffffff8028a433>] __do_softirq+0xf3/0x2b0
[   34.132025]  [<ffffffff802329fa>] call_softirq+0x1a/0x50
[   34.132025]  [<ffffffff80234ca9>] do_softirq+0xd9/0x1c0
[   34.132025]  [<ffffffff8028a333>] irq_exit+0xc3/0xd0
[   34.132025]  [<ffffffff80cf6a65>] do_IRQ+0x75/0x110
[   34.132025]  [<ffffffff80232393>] ret_from_intr+0x0/0x15
[   34.132025]  <EOI>  [<ffffffff80231622>] ? ftrace_caller+0x12/0x41
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80337d96>] ? free_page_and_swap_cache+0x16/0x80
[   34.132025]  [<ffffffff8032439f>] ? zap_pte_range+0x41f/0x580
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff80231656>] ? ftrace_call+0x5/0x2b
[   34.132025]  [<ffffffff803248c8>] ? unmap_page_range+0x3c8/0x3d0
[   34.132025]  [<ffffffff80324b9f>] ? unmap_vmas+0x2cf/0x390
[   34.132025]  [<ffffffff8032b2e0>] ? exit_mmap+0x130/0x1f0
[   34.132025]  [<ffffffff8027f628>] ? mmput+0x48/0x110
[   34.132025]  [<ffffffff8028542f>] ? exit_mm+0x14f/0x160
[   34.132025]  [<ffffffff80287a6a>] ? do_exit+0x24a/0x4d0
[   34.132025]  [<ffffffff80287d64>] ? do_group_exit+0x74/0x110
[   34.132025]  [<ffffffff80287e17>] ? sys_exit_group+0x17/0x20
[   34.132025]  [<ffffffff8023196f>] ? system_call_fastpath+0x16/0x1b
[   34.132025] ---[ end trace dd8d48ce9f465553 ]---
[   34.132025] Mapped at:
[   34.132025]  [<ffffffff8067fa37>] debug_dma_map_page+0x107/0x2a0
[   34.132025]  [<ffffffff8077711b>] e1000_tx_map+0x29b/0x870
[   34.132025]  [<ffffffff8077aa65>] e1000_xmit_frame+0x355/0x500
[   34.132025]  [<ffffffff80b54018>] dev_hard_start_xmit+0xb8/0x270
[   34.132025]  [<ffffffff80b775b0>] __qdisc_run+0x380/0x3b0
[   35.650726] ------------[ cut here ]------------

	Ingo
