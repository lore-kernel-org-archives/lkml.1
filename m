Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZIQVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZIQVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZIQVYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:24:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbZIQVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:24:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=EHHX2WFUj5Tvj+cEktZAPaAHl9ho72qOvez0IuSqv3VVaawE9vXjbKlj03xF9xaxb
	QM2UZ4MBnvWZ22mkApNFw==
Date: Thu, 17 Sep 2009 14:24:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Paris <eparis@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
In-Reply-To: <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com>
Message-ID: <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com> <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com> <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com> <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com> <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009, Eric Paris wrote:

> [   14.625084] udevd invoked oom-killer: gfp_mask=0x200da, order=0, oomkilladj=-17

Order-0 GFP_HIGHUSER_MOVABLE allocation from a task that is OOM_DISABLE.

> [   14.627347] udevd cpuset=/ mems_allowed=0
> [   14.628659] Pid: 776, comm: udevd Tainted: G        W  2.6.31 #145
> [   14.630408] Call Trace:
> [   14.631096]  [<ffffffff81112ed5>] __out_of_memory+0x1d5/0x1f0
> [   14.633489]  [<ffffffff81113184>] ? out_of_memory+0x1e4/0x220
> [   14.635323]  [<ffffffff81113132>] out_of_memory+0x192/0x220
> [   14.636307]  [<ffffffff81117764>] __alloc_pages_nodemask+0x694/0x6b0
> [   14.637785]  [<ffffffff81149a42>] alloc_page_vma+0x82/0x140
> [   14.638866]  [<ffffffff811304fa>] do_wp_page+0x10a/0x960

Writing to a shared page, the source of GFP_HIGHUSER_MOVABLE.

> [   14.639935]  [<ffffffff810ae666>] ? __lock_acquire+0x3c6/0x6d0
> [   14.641074]  [<ffffffff81130fd1>] ? handle_mm_fault+0x281/0x8d0
> [   14.642203]  [<ffffffff811313af>] handle_mm_fault+0x65f/0x8d0
> [   14.643191]  [<ffffffff81536095>] ? do_page_fault+0x1f5/0x470
> [   14.644484]  [<ffffffff81532aac>] ? _spin_unlock_irqrestore+0x5c/0xb0
> [   14.645715]  [<ffffffff81096166>] ? down_read_trylock+0x76/0x80
> [   14.646862]  [<ffffffff81536102>] do_page_fault+0x262/0x470
> [   14.647941]  [<ffffffff8153199e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [   14.649149]  [<ffffffff81533215>] page_fault+0x25/0x30
> [   14.650257] Mem-Info:
> [   14.650932] Node 0 DMA per-cpu:
> [   14.651718] CPU    0: hi:    0, btch:   1 usd:   0
> [   14.652670] CPU    1: hi:    0, btch:   1 usd:   0
> [   14.653680] CPU    2: hi:    0, btch:   1 usd:   0
> [   14.655669] CPU    3: hi:    0, btch:   1 usd:   0
> [   14.659353] CPU    4: hi:    0, btch:   1 usd:   0
> [   14.660280] CPU    5: hi:    0, btch:   1 usd:   0
> [   14.661642] Node 0 DMA32 per-cpu:
> [   14.663063] CPU    0: hi:  186, btch:  31 usd: 108
> [   14.664747] CPU    1: hi:  186, btch:  31 usd:  84
> [   14.666423] CPU    2: hi:  186, btch:  31 usd: 162
> [   14.668121] CPU    3: hi:  186, btch:  31 usd:  83
> [   14.669731] CPU    4: hi:  186, btch:  31 usd: 129
> [   14.671422] CPU    5: hi:  186, btch:  31 usd: 150
> [   14.673172] Active_anon:27531 active_file:17 inactive_anon:2293
> [   14.673174]  inactive_file:18 unevictable:0 dirty:0 writeback:0 unstable:0
> [   14.673175]  free:1172 slab:77543 mapped:32 pagetables:1046 bounce:0

303MB of slab, which is well over half your system's total memory 
capacity.

> [   14.679168] Node 0 DMA free:2004kB min:76kB low:92kB high:112kB active_anon:12532kB inactive_anon:128kB active_file:0kB inactive_file:4kB unevictable:0kB present:14140kB pages_scanned:0 all_unreclaimable? no
> [   14.683444] lowmem_reserve[]: 0 483 483 483
> [   14.684728] Node 0 DMA32 free:2684kB min:2772kB low:3464kB high:4156kB active_anon:97592kB inactive_anon:9044kB active_file:68kB inactive_file:68kB unevictable:0kB present:494944kB pages_scanned:650 all_unreclaimable? no
> [   14.688339] lowmem_reserve[]: 0 0 0 0
> [   14.689330] Node 0 DMA: 8*4kB 2*8kB 0*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2000kB
> [   14.695062] Node 0 DMA32: 19*4kB 2*8kB 0*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2684kB
> [   14.698175] 98 total pagecache pages
> [   14.699025] 0 pages in swap cache
> [   14.699968] Swap cache stats: add 0, delete 0, find 0/0
> [   14.701026] Free swap  = 0kB
> [   14.701786] Total swap = 0kB
> [   14.708232] 131056 pages RAM
> [   14.709022] 18283 pages reserved
> [   14.709803] 9774 pages shared
> [   14.710450] 109429 pages non-shared
> [   14.711298] [ pid ]   uid  tgid total_vm      rss cpu oom_adj name
> [   14.712287] [    1]     0     1    21723       43   5       0 init
> [   14.713833] [  776]     0   776     3362      276   2     -17 udevd
> [   14.715017] [  780]     0   780     3621      509   3     -17 udevd
> [   14.716186] [  782]     0   782     3691      588   2     -17 udevd
> [   14.717174] [  783]     0   783     3691      590   3     -17 udevd
> [   14.718516] [  785]     0   785     3592      503   2     -17 udevd
> [   14.719962] [  787]     0   787     3691      598   0     -17 udevd
> [   14.721166] [  789]     0   789     3559      462   1     -17 udevd
> [   14.722152] [  790]     0   790     3690      576   3     -17 udevd
> [   14.723558] [  791]     0   791     3724      615   0     -17 udevd
> [   14.724900] [  792]     0   792     3757      667   4     -17 udevd
> [   14.726116] [  794]     0   794     3784      673   3     -17 udevd
> [   14.727101] [  795]     0   795     3625      530   1     -17 udevd
> [   14.731047] [  796]     0   796     3658      567   4     -17 udevd
> [   14.732241] [  797]     0   797     3295      212   3     -17 udevd
> [   14.733226] [  798]     0   798     3757      667   3     -17 udevd
> [   14.734582] [  799]     0   799     3691      586   5     -17 udevd
> [   14.735852] [  800]     0   800     3757      669   0     -17 udevd
> [   14.737066] [  801]     0   801     3690      577   4     -17 udevd
> [   14.738243] [  802]     0   802     3685      596   0     -17 udevd
> [   14.739231] [  804]     0   804     3757      667   0     -17 udevd
> [   14.740665] [  805]     0   805     3757      669   0     -17 udevd
> [   14.741946] [  806]     0   806     3690      576   4     -17 udevd
> [   14.743151] [  808]     0   808     3724      616   4     -17 udevd
> [   14.744138] [  810]     0   810     3691      577   5     -17 udevd
> [   14.745583] [  812]     0   812     3757      666   1     -17 udevd
> [   14.746832] [  814]     0   814     3757      668   4     -17 udevd
> [   14.748017] [  815]     0   815     3592      499   1     -17 udevd
> [   14.749172] [  816]     0   816     3757      669   3     -17 udevd
> [   14.750161] [  817]     0   817     3526      423   5     -17 udevd
> [   14.751534] [  828]     0   828     3691      592   4     -17 udevd
> [   14.752859] [  832]     0   832     3757      661   2     -17 udevd
> [   14.754063] [  836]     0   836     3757      660   2     -17 udevd
> [   14.755267] [  837]     0   837     3757      662   5     -17 udevd
> [   14.756255] [  839]     0   839     3757      661   0     -17 udevd
> [   14.757634] [  840]     0   840     3757      663   4     -17 udevd
> [   14.758921] [  852]     0   852     3790      704   4     -17 udevd
> [   14.760091] [  856]     0   856     3691      593   4     -17 udevd
> [   14.761079] [  860]     0   860     3826      707   4     -17 udevd
> [   14.762403] [  861]     0   861     3818      707   1     -17 udevd
> [   14.765543] [  868]     0   868     3460      371   1     -17 udevd
> [   14.766766] [  870]     0   870     3724      627   0     -17 udevd
> [   14.768009] [  872]     0   872     3724      627   4     -17 udevd
> [   14.769186] [  877]     0   877     3724      627   5     -17 udevd
> [   14.770175] [  878]     0   878     3724      628   4     -17 udevd
> [   14.771487] [  880]     0   880     3724      628   5     -17 udevd
> [   14.772752] [  881]     0   881     3729      639   1     -17 udevd
> [   14.773932] [  882]     0   882     3485      379   2     -17 udevd
> [   14.775106] [  886]     0   886     3724      629   2     -17 udevd
> [   14.776093] [  887]     0   887     3724      627   4     -17 udevd
> [   14.777412] [  889]     0   889     3592      496   0     -17 udevd
> [   14.778400] [  890]     0   890     3724      627   1     -17 udevd
> [   14.779826] [  891]     0   891     3625      533   5     -17 udevd
> [   14.780980] [  892]     0   892     3427      316   1     -17 udevd
> [   14.782156] [  893]     0   893     3723      628   4     -17 udevd
> [   14.783144] [  894]     0   894     3748      635   4     -17 udevd
> [   14.784467] [  895]     0   895     3724      637   0     -17 udevd
> [   14.785669] [  896]     0   896     3559      450   4     -17 udevd
> [   14.786911] [  897]     0   897     3691      605   4     -17 udevd
> [   14.788076] [  898]     0   898     3724      638   1     -17 udevd
> [   14.789064] [  899]     0   899     3658      563   4     -17 udevd
> [   14.790377] [  900]     0   900     2888       14   4     -17 devkit-disks-pa
> [   14.791775] [  901]     0   901     3658      564   4     -17 udevd
> [   14.792949] [  902]     0   902     3691      605   3     -17 udevd
> [   14.794120] [  903]     0   903     1149      143   1     -17 modprobe
> [   14.795108] [  904]     0   904     3493      388   0     -17 udevd
> [   14.796471] [  905]     0   905       84        9   5     -17 console_check
> [   14.797862] [  906]     0   906     3625      521   4     -17 udevd
> [   14.800984] [  907]     0   907      827        9   4     -17 rename_device
> [   14.802262] [  908]     0   908     3625      531   0     -17 udevd
> [   14.803250] [  909]     0   909     3493      390   3     -17 udevd
> [   14.804579] [  910]     0   910     3460      363   1     -17 udevd
> [   14.805851] [  912]     0   912     3757      669   3     -17 udevd
> [   14.807011] [  913]     0   913     3362      276   5     -17 udevd

Looks udevd related, and you mentioned that this is the point where it 
always panics in your initial report.  It doesn't appear to be a VM issue.  
Finding that change between next-20090911 and next-20090914 may be time 
consuming.
