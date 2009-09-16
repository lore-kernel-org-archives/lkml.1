Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZIPOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZIPOgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZIPOgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:36:19 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:52931 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZIPOgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:36:18 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Wed, 16 Sep 2009 16:36:16 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
References: <200909060941.01810.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie> <200909091919.16461.elendil@planet.nl>
In-Reply-To: <200909091919.16461.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161636.20590.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2009 14:36:20.0751 (UTC) FILETIME=[0ECCA1F0:01CA36DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Frans Pop wrote:
> On Wednesday 09 September 2009, you wrote:
> > The problem with this theory is that the patches have been in since
> > Nov 2008 but reports are only showing up now.  Frans, how sure are you
> > that this is a recent problem? Is it readily reproducible?
>
> The only thing I can say here is that I've never seen the issue before
> (and thanks to logcheck I certainly would have).
> The laptop is in constant use, but I rarely stress the memory like that.
> Swap is almost always at 0.

JFYI, it happened again yesterday.
The first time it was swapper, here it's kcryptd. The top part of the
trace is the same.

kcryptd: page allocation failure. order:2, mode:0x4020
Pid: 1347, comm: kcryptd Not tainted 2.6.31-rc9 #16
Call Trace:
 <IRQ>  [<ffffffff810790b0>] __alloc_pages_nodemask+0x542/0x58a
 [<ffffffff81256a62>] ? _spin_unlock+0x9/0xb
 [<ffffffff811da481>] ? __alloc_skb+0x3c/0x15b
 [<ffffffffa0355644>] ? iwl_rx_allocate+0xac/0x208 [iwlcore]
 [<ffffffff81079153>] __get_free_pages+0x12/0x41
 [<ffffffff810982c5>] __kmalloc_track_caller+0x3b/0xec
 [<ffffffff811da4ab>] __alloc_skb+0x66/0x15b
 [<ffffffffa0355644>] iwl_rx_allocate+0xac/0x208 [iwlcore]
 [<ffffffffa03557b6>] iwl_rx_replenish_now+0x16/0x23 [iwlcore]
 [<ffffffffa037c8e3>] iwl_rx_handle+0x356/0x39a [iwlagn]
 [<ffffffffa00212a2>] ? scsi_io_completion+0x3a8/0x3d1 [scsi_mod]
 [<ffffffffa037ce27>] iwl_irq_tasklet_legacy+0x500/0x74f [iwlagn]
 [<ffffffffa001a81b>] ? scsi_finish_command+0xec/0xf5 [scsi_mod]
 [<ffffffff8103dff0>] tasklet_action+0x71/0xbc
 [<ffffffff8103e877>] __do_softirq+0x9b/0x12c
 [<ffffffff8100cb7c>] call_softirq+0x1c/0x28
 [<ffffffff8100e694>] do_softirq+0x34/0x72
 [<ffffffff8103e601>] irq_exit+0x3f/0x79
 [<ffffffff8100dd95>] do_IRQ+0xa3/0xba
 [<ffffffff8100c413>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa01fb5b8>] ? enc128+0x243/0x80b [aes_x86_64]
 [<ffffffffa01fc72b>] ? aes_encrypt+0xd/0xf [aes_x86_64]
 [<ffffffffa01e92b6>] ? crypto_cbc_encrypt+0x12c/0x18e [cbc]
 [<ffffffff81078c9b>] ? __alloc_pages_nodemask+0x12d/0x58a
 [<ffffffffa01fc71e>] ? aes_encrypt+0x0/0xf [aes_x86_64]
 [<ffffffff81113ea0>] ? async_encrypt+0x38/0x3a
 [<ffffffff81075a94>] ? mempool_alloc+0x5b/0x113
 [<ffffffffa01c5b53>] ? crypt_convert+0x1f9/0x278 [dm_crypt]
 [<ffffffffa01c5ff5>] ? kcryptd_crypt+0x423/0x449 [dm_crypt]
 [<ffffffffa01c5bd2>] ? kcryptd_crypt+0x0/0x449 [dm_crypt]
 [<ffffffff81048bc5>] ? worker_thread+0x132/0x1ca
 [<ffffffff8104c647>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81048a93>] ? worker_thread+0x0/0x1ca
 [<ffffffff8104c325>] ? kthread+0x8f/0x97
 [<ffffffff8100ca7a>] ? child_rip+0xa/0x20
 [<ffffffff8104c296>] ? kthread+0x0/0x97
 [<ffffffff8100ca70>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 172
CPU    1: hi:  186, btch:  31 usd: 163
Active_anon:278449 active_file:18846 inactive_anon:93192
 inactive_file:18343 unevictable:407 dirty:0 writeback:7726 unstable:0
 free:25175 slab:10409 mapped:34634 pagetables:4385 bounce:0
DMA free:7924kB min:40kB low:48kB high:60kB active_anon:2220kB inactive_anon:2464kB
   active_file:1084kB inactive_file:1608kB unevictable:0kB present:15336kB pages_scanned:0
   all_unreclaimable? no
lowmem_reserve[]: 0 1976 1976 1976
DMA32 free:92776kB min:5664kB low:7080kB high:8496kB active_anon:1111448kB inactive_anon:370432kB
   active_file:74300kB inactive_file:71764kB unevictable:1628kB present:2023748kB pages_scanned:32
   all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 63*4kB 59*8kB 26*16kB 34*32kB 23*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 7924kB
DMA32: 18882*4kB 2076*8kB 10*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 92776kB
82554 total pagecache pages
44961 pages in swap cache
Swap cache stats: add 160004, delete 115046, find 2431510/2434120
Free swap  = 1549576kB
Total swap = 2097144kB
518064 pages RAM
10323 pages reserved
117029 pages shared
398165 pages non-shared
iwlagn 0000:10:00.0: Can not allocate SKB buffers
kcryptd: page allocation failure. order:2, mode:0x4020
Pid: 1347, comm: kcryptd Not tainted 2.6.31-rc9 #16
Call Trace:
 <IRQ>  [<ffffffff810790b0>] __alloc_pages_nodemask+0x542/0x58a
 [<ffffffff81256a62>] ? _spin_unlock+0x9/0xb
 [<ffffffff811da481>] ? __alloc_skb+0x3c/0x15b
 [<ffffffffa0355644>] ? iwl_rx_allocate+0xac/0x208 [iwlcore]
 [<ffffffff81079153>] __get_free_pages+0x12/0x41
 [<ffffffff810982c5>] __kmalloc_track_caller+0x3b/0xec
 [<ffffffff811da4ab>] __alloc_skb+0x66/0x15b
 [<ffffffffa0355644>] iwl_rx_allocate+0xac/0x208 [iwlcore]
 [<ffffffffa03557b6>] iwl_rx_replenish_now+0x16/0x23 [iwlcore]
 [<ffffffffa037c90e>] iwl_rx_handle+0x381/0x39a [iwlagn]
 [<ffffffffa00212a2>] ? scsi_io_completion+0x3a8/0x3d1 [scsi_mod]
 [<ffffffffa037ce27>] iwl_irq_tasklet_legacy+0x500/0x74f [iwlagn]
 [<ffffffffa001a81b>] ? scsi_finish_command+0xec/0xf5 [scsi_mod]
 [<ffffffff8103dff0>] tasklet_action+0x71/0xbc
 [<ffffffff8103e877>] __do_softirq+0x9b/0x12c
 [<ffffffff8100cb7c>] call_softirq+0x1c/0x28
 [<ffffffff8100e694>] do_softirq+0x34/0x72
 [<ffffffff8103e601>] irq_exit+0x3f/0x79
 [<ffffffff8100dd95>] do_IRQ+0xa3/0xba
 [<ffffffff8100c413>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffffa01fb5b8>] ? enc128+0x243/0x80b [aes_x86_64]
 [<ffffffffa01fc72b>] ? aes_encrypt+0xd/0xf [aes_x86_64]
 [<ffffffffa01e92b6>] ? crypto_cbc_encrypt+0x12c/0x18e [cbc]
 [<ffffffff81078c9b>] ? __alloc_pages_nodemask+0x12d/0x58a
 [<ffffffffa01fc71e>] ? aes_encrypt+0x0/0xf [aes_x86_64]
 [<ffffffff81113ea0>] ? async_encrypt+0x38/0x3a
 [<ffffffff81075a94>] ? mempool_alloc+0x5b/0x113
 [<ffffffffa01c5b53>] ? crypt_convert+0x1f9/0x278 [dm_crypt]
 [<ffffffffa01c5ff5>] ? kcryptd_crypt+0x423/0x449 [dm_crypt]
 [<ffffffffa01c5bd2>] ? kcryptd_crypt+0x0/0x449 [dm_crypt]
 [<ffffffff81048bc5>] ? worker_thread+0x132/0x1ca
 [<ffffffff8104c647>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81048a93>] ? worker_thread+0x0/0x1ca
 [<ffffffff8104c325>] ? kthread+0x8f/0x97
 [<ffffffff8100ca7a>] ? child_rip+0xa/0x20
 [<ffffffff8104c296>] ? kthread+0x0/0x97
 [<ffffffff8100ca70>] ? child_rip+0x0/0x20
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 172
CPU    1: hi:  186, btch:  31 usd: 173
Active_anon:277951 active_file:18714 inactive_anon:93068
 inactive_file:18252 unevictable:407 dirty:0 writeback:7726 unstable:0
 free:25861 slab:10409 mapped:34634 pagetables:4385 bounce:0
DMA free:7924kB min:40kB low:48kB high:60kB active_anon:2220kB inactive_anon:2464kB
   active_file:1084kB inactive_file:1608kB unevictable:0kB present:15336kB pages_scanned:0
   all_unreclaimable? no
lowmem_reserve[]: 0 1976 1976 1976
DMA32 free:95520kB min:5664kB low:7080kB high:8496kB active_anon:1109584kB inactive_anon:369808kB
   active_file:73772kB inactive_file:71400kB unevictable:1628kB present:2023748kB pages_scanned:66
   all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 63*4kB 59*8kB 26*16kB 34*32kB 23*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 7924kB
DMA32: 19178*4kB 2285*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 95520kB
81717 total pagecache pages
44349 pages in swap cache
Swap cache stats: add 160008, delete 115659, find 2431510/2434120
Free swap  = 1549560kB
Total swap = 2097144kB
518064 pages RAM
10323 pages reserved
117031 pages shared
398265 pages non-shared
iwlagn 0000:10:00.0: Can not allocate SKB buffers
