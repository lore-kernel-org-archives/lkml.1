Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZANSmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZANSmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZANSmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:42:23 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:35296 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZANSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:42:21 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 13:42:20 EST
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: b44 - swapper: page allocation failure
Date: Wed, 14 Jan 2009 20:34:54 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901142034.55090.mihai.dontu@gmail.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.23160
X-BitDefender-Spam: No (241)
X-BitDefender-SpamStamp: v1, build 2.7.20.59161, bayes score: 500(0),
 pbayes score: 241(241), neunet score: 500(0), total: 241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A friend of mine just booted 2.6.28 and when someone else tried to send 
something to him over ssh (scp), the transfer failed and the following 
appeared in dmesg:

Pid: 0, comm: swapper Tainted: P           2.6.28-gentoo #1
Call Trace:
<IRQ>  [<ffffffff802a4e0d>] __alloc_pages_internal+0x3dd/0x4e0
[<ffffffff802cb273>] cache_alloc_refill+0x313/0x5b0
[<ffffffff802cb5fb>] __kmalloc+0xeb/0xf0
[<ffffffff806bb8ed>] __alloc_skb+0x6d/0x150
[<ffffffff8027ad90>] ktime_get_ts+0x30/0x60
[<ffffffff806bc457>] __netdev_alloc_skb+0x17/0x40
[<ffffffff804d6b5d>] b44_alloc_rx_skb+0x17d/0x740
[<ffffffff804d912d>] b44_poll+0x30d/0x620
[<ffffffff806bffc3>] net_rx_action+0x83/0x150
[<ffffffff80265e73>] __do_softirq+0x93/0x160
[<ffffffff8022c60c>] call_softirq+0x1c/0x30
[<ffffffff8022dfa5>] do_softirq+0x35/0x70
[<ffffffff80265b1d>] irq_exit+0x9d/0xb0
[<ffffffff8022e259>] do_IRQ+0xc9/0x110
[<ffffffff8022b896>] ret_from_intr+0x0/0xa
<EOI>  [<ffffffff8062fbe0>] menu_reflect+0x0/0x90
[<ffffffff804a4029>] acpi_idle_enter_simple+0x1c7/0x237
[<ffffffff804a401f>] acpi_idle_enter_simple+0x1bd/0x237
[<ffffffff8029934d>] rcu_needs_cpu+0x3d/0x50
[<ffffffff8062ee6a>] cpuidle_idle_call+0xba/0x120
[<ffffffff8022a46e>] cpu_idle+0x5e/0xc0
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  69
CPU    1: hi:  186, btch:  31 usd: 106
Active_anon:53932 active_file:23835 inactive_anon:1
inactive_file:49118 unevictable:0 dirty:7381 writeback:0 unstable:0
free:623763 slab:11485 mapped:24549 pagetables:2854 bounce:0
DMA free:4kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB 
active_file:0kB inactive_file:0kB unevictable:0kB present:4596kB 
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 3012 3012 3012
DMA32 free:2495048kB min:7016kB low:8768kB high:10524kB active_anon:215728kB 
inactive_anon:4kB active_file:95340kB inactive_file:196472kB unevictable:0kB 
present:3084968kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 
0*2048kB 0*4096kB = 4kB
DMA32: 1*4kB 34*8kB 55*16kB 17*32kB 6*64kB 4*128kB 2*256kB 3*512kB 2*1024kB 
1*2048kB 607*4096kB = 2495012kB
73068 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 2104472kB
Total swap = 2104472kB
786029 pages RAM
15043 pages reserved
96273 pages shared
105199 pages non-shared

-- 
Mihai Donțu
