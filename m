Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbZDXSNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbZDXSNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbZDXSNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:13:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:58811 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZDXSNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mKCsqsScdilFwWz7j2Mg6xg/eXaLGho1cUd7KmkE1eR5mfeFRkEkFSyIDyAujvvYbb
         ltSimbTzUknF3atReJsUVY3GcS/pE7JcNN+rZ06ZaPYLb/2yIce1H8Q0VWBTCFk28zXB
         jWhGnAswh3vaDCRx0CtwtapED7WoKI5zKfsUk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
Date: Fri, 24 Apr 2009 20:13:07 +0200
Message-ID: <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David

Thank you for your reply, as following:

On Fri, Apr 24, 2009 at 7:17 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 24 Apr 2009, Zeno Davatz wrote:
>> Linux thinpower 2.6.29 #5 SMP Sun Apr 5 20:04:08 UTC 2009 x86_64
>> Intel(R) Xeon(R) CPU E5450 @ 3.00GHz GenuineIntel GNU/Linux
>>
>> This morning our Server ran out of memory and had to be hard rebooted.
>> The system hast 32 GB or memory and 4 QuadCore Xeon CPUs.
>> /var/log/kernel/current tells us the following:
>>
>> Apr 24 09:01:06 thinpower [1349923.491914] postgres invoked
>> oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
>> Apr 24 09:01:06 thinpower [1349923.491919] postgres cpuset=/ mems_allowed=0
>> Apr 24 09:01:06 thinpower [1349923.491922] Pid: 2393, comm: postgres
>> Not tainted 2.6.29 #5
>> Apr 24 09:01:06 thinpower [1349923.491924] Call Trace:
>> Apr 24 09:01:06 thinpower [1349923.491934]  [<ffffffff8106eda9>] ?
>> cpuset_print_task_mems_allowed+0x99/0x9f
>> Apr 24 09:01:06 thinpower [1349923.491939]  [<ffffffff81083d28>]
>> oom_kill_process+0x96/0x246
>> Apr 24 09:01:06 thinpower [1349923.491942]  [<ffffffff8106dcf0>] ?
>> cpuset_mems_allowed_intersects+0x1c/0x1e
>> Apr 24 09:01:06 thinpower [1349923.491944]  [<ffffffff810840a5>] ?
>> badness+0x1a3/0x1e6
>> Apr 24 09:01:06 thinpower [1349923.491946]  [<ffffffff8108421c>]
>> __out_of_memory+0x134/0x14b
>> Apr 24 09:01:06 thinpower [1349923.491949]  [<ffffffff8108438b>]
>> out_of_memory+0x158/0x18a
>> Apr 24 09:01:06 thinpower [1349923.491951]  [<ffffffff81087906>]
>> __alloc_pages_internal+0x372/0x434
>> Apr 24 09:01:06 thinpower [1349923.491954]  [<ffffffff810aa490>]
>> alloc_pages_current+0xb9/0xc2
>> Apr 24 09:01:06 thinpower [1349923.491957]  [<ffffffff81081a59>]
>> __page_cache_alloc+0x67/0x6b
>> Apr 24 09:01:06 thinpower [1349923.491959]  [<ffffffff81089426>]
>> __do_page_cache_readahead+0x96/0x192
>> Apr 24 09:01:06 thinpower [1349923.491961]  [<ffffffff81089575>]
>> do_page_cache_readahead+0x53/0x60
>> Apr 24 09:01:06 thinpower [1349923.491963]  [<ffffffff81081ec7>]
>> filemap_fault+0x15e/0x313
>> Apr 24 09:01:06 thinpower [1349923.491967]  [<ffffffff81094451>]
>> __do_fault+0x53/0x393
>> Apr 24 09:01:06 thinpower [1349923.491969]  [<ffffffff81030531>] ?
>> __wake_up_sync+0x45/0x4e
>> Apr 24 09:01:06 thinpower [1349923.491972]  [<ffffffff81096702>]
>> handle_mm_fault+0x36b/0x854
>> Apr 24 09:01:06 thinpower [1349923.491976]  [<ffffffff813a1acb>] ?
>> release_sock+0xb0/0xbb
>> Apr 24 09:01:06 thinpower [1349923.491979]  [<ffffffff81022c8f>] ?
>> default_spin_lock_flags+0x9/0xe
>> Apr 24 09:01:06 thinpower [1349923.491984]  [<ffffffff814ac6fe>]
>> do_page_fault+0x662/0xa5c
>> Apr 24 09:01:06 thinpower [1349923.491988]  [<ffffffff81400b8e>] ?
>> inet_sendmsg+0x46/0x53
>> Apr 24 09:01:06 thinpower [1349923.491992]  [<ffffffff8139ed97>] ?
>> __sock_sendmsg+0x59/0x62
>> Apr 24 09:01:06 thinpower [1349923.491994]  [<ffffffff8139f6d8>] ?
>> sock_sendmsg+0xc7/0xe0
>> Apr 24 09:01:06 thinpower [1349923.491996]  [<ffffffff81086b5e>] ?
>> free_pages+0x32/0x36
>> Apr 24 09:01:06 thinpower [1349923.492000]  [<ffffffff8104e7ec>] ?
>> autoremove_wake_function+0x0/0x38
>> Apr 24 09:01:06 thinpower [1349923.492004]  [<ffffffff810c1d76>] ?
>> core_sys_select+0x1df/0x213
>> Apr 24 09:01:06 thinpower [1349923.492007]  [<ffffffff810b2cc2>] ?
>> nameidata_to_filp+0x41/0x52
>> Apr 24 09:01:06 thinpower [1349923.492009]  [<ffffffff8139f028>] ?
>> sockfd_lookup_light+0x1b/0x54
>> Apr 24 09:01:06 thinpower [1349923.492013]  [<ffffffff81011ac8>] ?
>> read_tsc+0xe/0x24
>> Apr 24 09:01:06 thinpower [1349923.492017]  [<ffffffff81055990>] ?
>> getnstimeofday+0x58/0xb4
>> Apr 24 09:01:06 thinpower [1349923.492019]  [<ffffffff810516ed>] ?
>> ktime_get_ts+0x49/0x4e
>> Apr 24 09:01:06 thinpower [1349923.492022]  [<ffffffff810c0d35>] ?
>> poll_select_copy_remaining+0xc5/0xea
>> Apr 24 09:01:06 thinpower [1349923.492023]  [<ffffffff810c1ff3>] ?
>> sys_select+0xa7/0xbc
>> Apr 24 09:01:06 thinpower [1349923.492026]  [<ffffffff814aa305>]
>> page_fault+0x25/0x30
>>
>
> Are these the last messages in the dmesg?  There should be subsequent
> information that describes the current state of memory following the stack
> trace.

These are the last messages from /var/log/kernel/current - [[ let me
know if you need more ]]

Apr 24 09:01:00 thinpower [1349916.950049] CPU    0: hi:  186, btch:
31 usd: 110
Apr 24 09:01:00 thinpower [1349916.950051] CPU    1: hi:  186, btch:
31 usd: 111
Apr 24 09:01:00 thinpower [1349916.950052] CPU    2: hi:  186, btch:
31 usd: 162
Apr 24 09:01:00 thinpower [1349916.950053] CPU    3: hi:  186, btch:
31 usd: 157
Apr 24 09:01:00 thinpower [1349916.950055] CPU    4: hi:  186, btch:
31 usd: 109
Apr 24 09:01:00 thinpower [1349916.950056] CPU    5: hi:  186, btch:
31 usd: 102
Apr 24 09:01:00 thinpower [1349916.950057] CPU    6: hi:  186, btch:
31 usd: 179
Apr 24 09:01:00 thinpower [1349916.950058] CPU    7: hi:  186, btch:
31 usd: 123
Apr 24 09:01:00 thinpower [1349916.950061] Active_anon:7600155
active_file:0 inactive_anon:552800
Apr 24 09:01:00 thinpower [1349916.950061]  inactive_file:5
unevictable:0 dirty:0 writeback:0 unstable:0
Apr 24 09:01:00 thinpower [1349916.950062]  free:38559 slab:12539
mapped:2 pagetables:22733 bounce:0
Apr 24 09:01:00 thinpower [1349916.950064] Node 0 DMA free:15700kB
min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB present:15156kB
pages_scanned:0 all_unreclaimable? yes
Apr 24 09:01:00 thinpower [1349916.950067] lowmem_reserve[]: 0 3255 32292 32292
Apr 24 09:01:00 thinpower [1349916.950070] Node 0 DMA32 free:117732kB
min:2316kB low:2892kB high:3472kB active_anon:2266592kB
inactive_anon:453072kB active_file:0kB inactive_file:4kB
unevictable:0kB present:3333280kB pages_scanned:1587467
all_unreclaimable? no
Apr 24 09:01:00 thinpower [1349916.950074] lowmem_reserve[]: 0 0 29037 29037
Apr 24 09:01:00 thinpower [1349916.950076] Node 0 Normal free:20804kB
min:20672kB low:25840kB high:31008kB active_anon:28134028kB
inactive_anon:1758128kB active_file:0kB inactive_file:16kB
unevictable:0kB present:29734400kB pages_scanned:896
all_unreclaimable? no
Apr 24 09:01:00 thinpower [1349916.950080] lowmem_reserve[]: 0 0 0 0
Apr 24 09:01:00 thinpower [1349916.950082] Node 0 DMA: 1*4kB 0*8kB
1*16kB 2*32kB 2*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15700kB
Apr 24 09:01:00 thinpower [1349916.950089] Node 0 DMA32: 159*4kB
127*8kB 59*16kB 14*32kB 12*64kB 6*128kB 20*256kB 15*512kB 6*1024kB
2*2048kB 22*4096kB = 117732kB
Apr 24 09:01:00 thinpower [1349916.950095] Node 0 Normal: 93*4kB 8*8kB
54*16kB 11*32kB 2*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB
4*4096kB = 21108kB
Apr 24 09:01:00 thinpower [1349916.950101] 6946 total pagecache pages
Apr 24 09:01:00 thinpower [1349916.950102] 0 pages in swap cache
Apr 24 09:01:00 thinpower [1349916.950104] Swap cache stats: add 0,
delete 0, find 0/0
Apr 24 09:01:00 thinpower [1349916.950105] Free swap  = 0kB
Apr 24 09:01:00 thinpower [1349916.950106] Total swap = 0kB
Apr 24 09:01:00 thinpower [1349917.149549] 8388592 pages RAM
Apr 24 09:01:00 thinpower [1349917.149551] 136791 pages reserved
Apr 24 09:01:00 thinpower [1349917.149552] 66429 pages shared
Apr 24 09:01:00 thinpower [1349917.149553] 8206765 pages non-shared
Apr 24 09:01:00 thinpower [1349917.149556] Out of memory: kill process
21692 (ruby) score 58368 or a child
Apr 24 09:01:00 thinpower [1349917.149621] Killed process 21692 (ruby)
Apr 24 09:01:06 thinpower [1349923.491914] postgres invoked
oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Apr 24 09:01:06 thinpower [1349923.491919] postgres cpuset=/ mems_allowed=0
Apr 24 09:01:06 thinpower [1349923.491922] Pid: 2393, comm: postgres
Not tainted 2.6.29 #5
Apr 24 09:01:06 thinpower [1349923.491924] Call Trace:
Apr 24 09:01:06 thinpower [1349923.491934]  [<ffffffff8106eda9>] ?
cpuset_print_task_mems_allowed+0x99/0x9f
Apr 24 09:01:06 thinpower [1349923.491939]  [<ffffffff81083d28>]
oom_kill_process+0x96/0x246
Apr 24 09:01:06 thinpower [1349923.491942]  [<ffffffff8106dcf0>] ?
cpuset_mems_allowed_intersects+0x1c/0x1e
Apr 24 09:01:06 thinpower [1349923.491944]  [<ffffffff810840a5>] ?
badness+0x1a3/0x1e6
Apr 24 09:01:06 thinpower [1349923.491946]  [<ffffffff8108421c>]
__out_of_memory+0x134/0x14b
Apr 24 09:01:06 thinpower [1349923.491949]  [<ffffffff8108438b>]
out_of_memory+0x158/0x18a
Apr 24 09:01:06 thinpower [1349923.491951]  [<ffffffff81087906>]
__alloc_pages_internal+0x372/0x434
Apr 24 09:01:06 thinpower [1349923.491954]  [<ffffffff810aa490>]
alloc_pages_current+0xb9/0xc2
Apr 24 09:01:06 thinpower [1349923.491957]  [<ffffffff81081a59>]
__page_cache_alloc+0x67/0x6b
Apr 24 09:01:06 thinpower [1349923.491959]  [<ffffffff81089426>]
__do_page_cache_readahead+0x96/0x192
Apr 24 09:01:06 thinpower [1349923.491961]  [<ffffffff81089575>]
do_page_cache_readahead+0x53/0x60
Apr 24 09:01:06 thinpower [1349923.491963]  [<ffffffff81081ec7>]
filemap_fault+0x15e/0x313
Apr 24 09:01:06 thinpower [1349923.491967]  [<ffffffff81094451>]
__do_fault+0x53/0x393
Apr 24 09:01:06 thinpower [1349923.491969]  [<ffffffff81030531>] ?
__wake_up_sync+0x45/0x4e
Apr 24 09:01:06 thinpower [1349923.491972]  [<ffffffff81096702>]
handle_mm_fault+0x36b/0x854
Apr 24 09:01:06 thinpower [1349923.491976]  [<ffffffff813a1acb>] ?
release_sock+0xb0/0xbb
Apr 24 09:01:06 thinpower [1349923.491979]  [<ffffffff81022c8f>] ?
default_spin_lock_flags+0x9/0xe
Apr 24 09:01:06 thinpower [1349923.491984]  [<ffffffff814ac6fe>]
do_page_fault+0x662/0xa5c
Apr 24 09:01:06 thinpower [1349923.491988]  [<ffffffff81400b8e>] ?
inet_sendmsg+0x46/0x53
Apr 24 09:01:06 thinpower [1349923.491992]  [<ffffffff8139ed97>] ?
__sock_sendmsg+0x59/0x62
Apr 24 09:01:06 thinpower [1349923.491994]  [<ffffffff8139f6d8>] ?
sock_sendmsg+0xc7/0xe0
Apr 24 09:01:06 thinpower [1349923.491996]  [<ffffffff81086b5e>] ?
free_pages+0x32/0x36
Apr 24 09:01:06 thinpower [1349923.492000]  [<ffffffff8104e7ec>] ?
autoremove_wake_function+0x0/0x38
Apr 24 09:01:06 thinpower [1349923.492004]  [<ffffffff810c1d76>] ?
core_sys_select+0x1df/0x213
Apr 24 09:01:06 thinpower [1349923.492007]  [<ffffffff810b2cc2>] ?
nameidata_to_filp+0x41/0x52
Apr 24 09:01:06 thinpower [1349923.492009]  [<ffffffff8139f028>] ?
sockfd_lookup_light+0x1b/0x54
Apr 24 09:01:06 thinpower [1349923.492013]  [<ffffffff81011ac8>] ?
read_tsc+0xe/0x24
Apr 24 09:01:06 thinpower [1349923.492017]  [<ffffffff81055990>] ?
getnstimeofday+0x58/0xb4
Apr 24 09:01:06 thinpower [1349923.492019]  [<ffffffff810516ed>] ?
ktime_get_ts+0x49/0x4e
Apr 24 09:01:06 thinpower [1349923.492022]  [<ffffffff810c0d35>] ?
poll_select_copy_remaining+0xc5/0xea
Apr 24 09:01:06 thinpower [1349923.492023]  [<ffffffff810c1ff3>] ?
sys_select+0xa7/0xbc
Apr 24 09:01:06 thinpower [1349923.492026]  [<ffffffff814aa305>]
page_fault+0x25/0x30
Apr 24 09:01:06 thinpower [1349923.492028] Mem-Info:
Apr 24 09:01:06 thinpower [1349923.492029] Node 0 DMA per-cpu:
Apr 24 09:01:06 thinpower [1349923.492031] CPU    0: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492032] CPU    1: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492034] CPU    2: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492035] CPU    3: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492036] CPU    4: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492037] CPU    5: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492039] CPU    6: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492040] CPU    7: hi:    0, btch:
1 usd:   0
Apr 24 09:01:06 thinpower [1349923.492041] Node 0 DMA32 per-cpu:
Apr 24 09:01:06 thinpower [1349923.492043] CPU    0: hi:  186, btch:
31 usd:  29
Apr 24 09:01:06 thinpower [1349923.492044] CPU    1: hi:  186, btch:
31 usd:  17
Apr 24 09:01:06 thinpower [1349923.492046] CPU    2: hi:  186, btch:
31 usd: 176
Apr 24 09:01:06 thinpower [1349923.492047] CPU    3: hi:  186, btch:
31 usd:  19
Apr 24 09:01:06 thinpower [1349923.492048] CPU    4: hi:  186, btch:
31 usd:  29
Apr 24 09:01:06 thinpower [1349923.492050] CPU    5: hi:  186, btch:
31 usd:   0
Apr 24 09:01:06 thinpower [1349923.492051] CPU    6: hi:  186, btch:
31 usd:   0
Apr 24 09:01:06 thinpower [1349923.492052] CPU    7: hi:  186, btch:
31 usd:  31
Apr 24 09:01:06 thinpower [1349923.492053] Node 0 Normal per-cpu:
Apr 24 09:01:06 thinpower [1349923.492055] CPU    0: hi:  186, btch:
31 usd:  50
Apr 24 09:01:06 thinpower [1349923.492056] CPU    1: hi:  186, btch:
31 usd:  20
Apr 24 09:01:06 thinpower [1349923.492057] CPU    2: hi:  186, btch:
31 usd:  42
Apr 24 09:01:06 thinpower [1349923.492059] CPU    3: hi:  186, btch:
31 usd: 124
Apr 24 09:01:06 thinpower [1349923.492060] CPU    4: hi:  186, btch:
31 usd: 104
Apr 24 09:01:06 thinpower [1349923.492061] CPU    5: hi:  186, btch:
31 usd:  95
Apr 24 09:01:06 thinpower [1349923.492062] CPU    6: hi:  186, btch:
31 usd: 178
Apr 24 09:01:06 thinpower [1349923.492064] CPU    7: hi:  186, btch:
31 usd:  60
Apr 24 09:01:06 thinpower [1349923.492066] Active_anon:7595417
active_file:641 inactive_anon:551929
Apr 24 09:01:06 thinpower [1349923.492067]  inactive_file:5122
unevictable:0 dirty:0 writeback:0 unstable:0
Apr 24 09:01:06 thinpower [1349923.492068]  free:39401 slab:12443
mapped:1801 pagetables:22566 bounce:0
Apr 24 09:01:06 thinpower [1349923.492069] Node 0 DMA free:15700kB
min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB present:15156kB
pages_scanned:0 all_unreclaimable? yes
Apr 24 09:01:06 thinpower [1349923.492073] lowmem_reserve[]: 0 3255 32292 32292
Apr 24 09:01:06 thinpower [1349923.492076] Node 0 DMA32 free:118848kB
min:2316kB low:2892kB high:3472kB active_anon:2265276kB
inactive_anon:452944kB active_file:4kB inactive_file:0kB
unevictable:0kB present:3333280kB pages_scanned:2692832
all_unreclaimable? no
Apr 24 09:01:06 thinpower [1349923.492080] lowmem_reserve[]: 0 0 29037 29037
Apr 24 09:01:06 thinpower [1349923.492082] Node 0 Normal free:23056kB
min:20672kB low:25840kB high:31008kB active_anon:28116392kB
inactive_anon:1754772kB active_file:2560kB inactive_file:20488kB
unevictable:0kB present:29734400kB pages_scanned:77696
all_unreclaimable? no
Apr 24 09:01:06 thinpower [1349923.492086] lowmem_reserve[]: 0 0 0 0
Apr 24 09:01:06 thinpower [1349923.492088] Node 0 DMA: 1*4kB 0*8kB
1*16kB 2*32kB 2*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15700kB
Apr 24 09:01:06 thinpower [1349923.492095] Node 0 DMA32: 172*4kB
134*8kB 66*16kB 18*32kB 18*64kB 7*128kB 21*256kB 15*512kB 6*1024kB
2*2048kB 22*4096kB = 118848kB
Apr 24 09:01:06 thinpower [1349923.492101] Node 0 Normal: 251*4kB
24*8kB 144*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB
1*2048kB 4*4096kB = 22924kB
Apr 24 09:01:06 thinpower [1349923.492107] 12705 total pagecache pages
Apr 24 09:01:06 thinpower [1349923.492108] 0 pages in swap cache
Apr 24 09:01:06 thinpower [1349923.492109] Swap cache stats: add 0,
delete 0, find 0/0
Apr 24 09:01:06 thinpower [1349923.492110] Free swap  = 0kB
Apr 24 09:01:06 thinpower [1349923.492111] Total swap = 0kB
Apr 24 09:01:06 thinpower [1349923.693323] 8388592 pages RAM
Apr 24 09:01:06 thinpower [1349923.693326] 136791 pages reserved
Apr 24 09:01:06 thinpower [1349923.693327] 69633 pages shared
Apr 24 09:01:06 thinpower [1349923.693328] 8205493 pages non-shared
Apr 24 09:01:06 thinpower [1349923.693331] Out of memory: kill process
21490 (apache2) score 53801 or a child
Apr 24 09:01:06 thinpower [1349923.693410] Killed process 21490 (apache2)

> If this is reproducible, I'd recommend enabling
> /proc/sys/vm/oom_dump_tasks so that the oom killer will dump the tasklist
> and show us what may be causing the livelock.

Ok, how do I enable that? I will google for it.

If we can reproduce it, I will let you know.

>> Before that we had this:
>>
>> Apr 24 08:59:24 thinpower [1349806.982419] 6954 total pagecache pages
>> Apr 24 08:59:24 thinpower [1349806.982420] 0 pages in swap cache
>> Apr 24 08:59:24 thinpower [1349806.982422] Swap cache stats: add 0,
>> delete 0, find 0/0
>> Apr 24 08:59:24 thinpower [1349806.982423] Free swap  = 0kB
>> Apr 24 08:59:24 thinpower [1349806.982423] Total swap = 0kB
>> Apr 24 08:59:24 thinpower [1349807.182725] 8388592 pages RAM
>> Apr 24 08:59:24 thinpower [1349807.182728] 136791 pages reserved
>> Apr 24 08:59:24 thinpower [1349807.182729] 35053 pages shared
>> Apr 24 08:59:24 thinpower [1349807.182729] 8207346 pages non-shared
>> Apr 24 08:59:24 thinpower [1349807.182732] Out of memory: kill process
>> 21592 (ruby) score 109489 or a child
>> Apr 24 08:59:24 thinpower [1349807.182795] Killed process 21592 (ruby)
>> Apr 24 09:00:59 thinpower [1349916.949909] apache2 invoked oom-killer:
>> gfp_mask=0x1201d2, order=0, oomkilladj=0
>
> apache2 in this case (and postgres later) are valid oom killer targets
> because their /proc/pid/oom_adj score is 0.  The only reason they wouldn't
> be getting killed subsequently is because the already killed tasks, ruby,
> is PF_EXITING and has failed to exit.  It has access to memory reserves
> and if it hangs before dying, the machine will livelock.

Thanks for the info. We will try to chew on this.

Best
Zeno
