Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbZDXRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbZDXRRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZDXRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:17:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:55359 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZDXRRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:17:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=q1Csvlwza9PDDSH/CT5vJZzNfX81iGFIsSzPK2U/MzlhbwQBXj+AeenvMYV5y02xN
	BKgPw90kTrh0vgrk8VGqg==
Date: Fri, 24 Apr 2009 10:17:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zeno Davatz <zdavatz@gmail.com>
cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
In-Reply-To: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Zeno Davatz wrote:

> Dear All
> 
> Our Kernel-Version:
> 
> Linux thinpower 2.6.29 #5 SMP Sun Apr 5 20:04:08 UTC 2009 x86_64
> Intel(R) Xeon(R) CPU E5450 @ 3.00GHz GenuineIntel GNU/Linux
> 
> This morning our Server ran out of memory and had to be hard rebooted.
> The system hast 32 GB or memory and 4 QuadCore Xeon CPUs.
> /var/log/kernel/current tells us the following:
> 
> Apr 24 09:01:06 thinpower [1349923.491914] postgres invoked
> oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> Apr 24 09:01:06 thinpower [1349923.491919] postgres cpuset=/ mems_allowed=0
> Apr 24 09:01:06 thinpower [1349923.491922] Pid: 2393, comm: postgres
> Not tainted 2.6.29 #5
> Apr 24 09:01:06 thinpower [1349923.491924] Call Trace:
> Apr 24 09:01:06 thinpower [1349923.491934]  [<ffffffff8106eda9>] ?
> cpuset_print_task_mems_allowed+0x99/0x9f
> Apr 24 09:01:06 thinpower [1349923.491939]  [<ffffffff81083d28>]
> oom_kill_process+0x96/0x246
> Apr 24 09:01:06 thinpower [1349923.491942]  [<ffffffff8106dcf0>] ?
> cpuset_mems_allowed_intersects+0x1c/0x1e
> Apr 24 09:01:06 thinpower [1349923.491944]  [<ffffffff810840a5>] ?
> badness+0x1a3/0x1e6
> Apr 24 09:01:06 thinpower [1349923.491946]  [<ffffffff8108421c>]
> __out_of_memory+0x134/0x14b
> Apr 24 09:01:06 thinpower [1349923.491949]  [<ffffffff8108438b>]
> out_of_memory+0x158/0x18a
> Apr 24 09:01:06 thinpower [1349923.491951]  [<ffffffff81087906>]
> __alloc_pages_internal+0x372/0x434
> Apr 24 09:01:06 thinpower [1349923.491954]  [<ffffffff810aa490>]
> alloc_pages_current+0xb9/0xc2
> Apr 24 09:01:06 thinpower [1349923.491957]  [<ffffffff81081a59>]
> __page_cache_alloc+0x67/0x6b
> Apr 24 09:01:06 thinpower [1349923.491959]  [<ffffffff81089426>]
> __do_page_cache_readahead+0x96/0x192
> Apr 24 09:01:06 thinpower [1349923.491961]  [<ffffffff81089575>]
> do_page_cache_readahead+0x53/0x60
> Apr 24 09:01:06 thinpower [1349923.491963]  [<ffffffff81081ec7>]
> filemap_fault+0x15e/0x313
> Apr 24 09:01:06 thinpower [1349923.491967]  [<ffffffff81094451>]
> __do_fault+0x53/0x393
> Apr 24 09:01:06 thinpower [1349923.491969]  [<ffffffff81030531>] ?
> __wake_up_sync+0x45/0x4e
> Apr 24 09:01:06 thinpower [1349923.491972]  [<ffffffff81096702>]
> handle_mm_fault+0x36b/0x854
> Apr 24 09:01:06 thinpower [1349923.491976]  [<ffffffff813a1acb>] ?
> release_sock+0xb0/0xbb
> Apr 24 09:01:06 thinpower [1349923.491979]  [<ffffffff81022c8f>] ?
> default_spin_lock_flags+0x9/0xe
> Apr 24 09:01:06 thinpower [1349923.491984]  [<ffffffff814ac6fe>]
> do_page_fault+0x662/0xa5c
> Apr 24 09:01:06 thinpower [1349923.491988]  [<ffffffff81400b8e>] ?
> inet_sendmsg+0x46/0x53
> Apr 24 09:01:06 thinpower [1349923.491992]  [<ffffffff8139ed97>] ?
> __sock_sendmsg+0x59/0x62
> Apr 24 09:01:06 thinpower [1349923.491994]  [<ffffffff8139f6d8>] ?
> sock_sendmsg+0xc7/0xe0
> Apr 24 09:01:06 thinpower [1349923.491996]  [<ffffffff81086b5e>] ?
> free_pages+0x32/0x36
> Apr 24 09:01:06 thinpower [1349923.492000]  [<ffffffff8104e7ec>] ?
> autoremove_wake_function+0x0/0x38
> Apr 24 09:01:06 thinpower [1349923.492004]  [<ffffffff810c1d76>] ?
> core_sys_select+0x1df/0x213
> Apr 24 09:01:06 thinpower [1349923.492007]  [<ffffffff810b2cc2>] ?
> nameidata_to_filp+0x41/0x52
> Apr 24 09:01:06 thinpower [1349923.492009]  [<ffffffff8139f028>] ?
> sockfd_lookup_light+0x1b/0x54
> Apr 24 09:01:06 thinpower [1349923.492013]  [<ffffffff81011ac8>] ?
> read_tsc+0xe/0x24
> Apr 24 09:01:06 thinpower [1349923.492017]  [<ffffffff81055990>] ?
> getnstimeofday+0x58/0xb4
> Apr 24 09:01:06 thinpower [1349923.492019]  [<ffffffff810516ed>] ?
> ktime_get_ts+0x49/0x4e
> Apr 24 09:01:06 thinpower [1349923.492022]  [<ffffffff810c0d35>] ?
> poll_select_copy_remaining+0xc5/0xea
> Apr 24 09:01:06 thinpower [1349923.492023]  [<ffffffff810c1ff3>] ?
> sys_select+0xa7/0xbc
> Apr 24 09:01:06 thinpower [1349923.492026]  [<ffffffff814aa305>]
> page_fault+0x25/0x30
> 

Are these the last messages in the dmesg?  There should be subsequent 
information that describes the current state of memory following the stack 
trace.

If this is reproducible, I'd recommend enabling 
/proc/sys/vm/oom_dump_tasks so that the oom killer will dump the tasklist 
and show us what may be causing the livelock.

> Before that we had this:
> 
> Apr 24 08:59:24 thinpower [1349806.982419] 6954 total pagecache pages
> Apr 24 08:59:24 thinpower [1349806.982420] 0 pages in swap cache
> Apr 24 08:59:24 thinpower [1349806.982422] Swap cache stats: add 0,
> delete 0, find 0/0
> Apr 24 08:59:24 thinpower [1349806.982423] Free swap  = 0kB
> Apr 24 08:59:24 thinpower [1349806.982423] Total swap = 0kB
> Apr 24 08:59:24 thinpower [1349807.182725] 8388592 pages RAM
> Apr 24 08:59:24 thinpower [1349807.182728] 136791 pages reserved
> Apr 24 08:59:24 thinpower [1349807.182729] 35053 pages shared
> Apr 24 08:59:24 thinpower [1349807.182729] 8207346 pages non-shared
> Apr 24 08:59:24 thinpower [1349807.182732] Out of memory: kill process
> 21592 (ruby) score 109489 or a child
> Apr 24 08:59:24 thinpower [1349807.182795] Killed process 21592 (ruby)
> Apr 24 09:00:59 thinpower [1349916.949909] apache2 invoked oom-killer:
> gfp_mask=0x1201d2, order=0, oomkilladj=0

apache2 in this case (and postgres later) are valid oom killer targets 
because their /proc/pid/oom_adj score is 0.  The only reason they wouldn't 
be getting killed subsequently is because the already killed tasks, ruby, 
is PF_EXITING and has failed to exit.  It has access to memory reserves 
and if it hangs before dying, the machine will livelock.

> Apr 24 09:01:00 thinpower [1349916.949915] apache2 cpuset=/ mems_allowed=0
> Apr 24 09:01:00 thinpower [1349916.949918] Pid: 21599, comm: apache2
> Not tainted 2.6.29 #5
> Apr 24 09:01:00 thinpower [1349916.949920] Call Trace:
> Apr 24 09:01:00 thinpower [1349916.949930]  [<ffffffff8106eda9>] ?
> cpuset_print_task_mems_allowed+0x99/0x9f
> Apr 24 09:01:00 thinpower [1349916.949936]  [<ffffffff81083d28>]
> oom_kill_process+0x96/0x246
> Apr 24 09:01:00 thinpower [1349916.949938]  [<ffffffff8106dcf0>] ?
> cpuset_mems_allowed_intersects+0x1c/0x1e
> Apr 24 09:01:00 thinpower [1349916.949940]  [<ffffffff810840a5>] ?
> badness+0x1a3/0x1e6
> Apr 24 09:01:00 thinpower [1349916.949942]  [<ffffffff8108421c>]
> __out_of_memory+0x134/0x14b
> Apr 24 09:01:00 thinpower [1349916.949945]  [<ffffffff8108438b>]
> out_of_memory+0x158/0x18a
> Apr 24 09:01:00 thinpower [1349916.949947]  [<ffffffff81087906>]
> __alloc_pages_internal+0x372/0x434
> Apr 24 09:01:00 thinpower [1349916.949950]  [<ffffffff810aa490>]
> alloc_pages_current+0xb9/0xc2
> Apr 24 09:01:00 thinpower [1349916.949953]  [<ffffffff81081a59>]
> __page_cache_alloc+0x67/0x6b
> Apr 24 09:01:00 thinpower [1349916.949954]  [<ffffffff81081841>] ?
> sync_page+0x0/0x40
> Apr 24 09:01:00 thinpower [1349916.949957]  [<ffffffff81089426>]
> __do_page_cache_readahead+0x96/0x192
> Apr 24 09:01:00 thinpower [1349916.949959]  [<ffffffff81089575>]
> do_page_cache_readahead+0x53/0x60
> Apr 24 09:01:00 thinpower [1349916.949961]  [<ffffffff81081ec7>]
> filemap_fault+0x15e/0x313
> Apr 24 09:01:00 thinpower [1349916.949964]  [<ffffffff81094451>]
> __do_fault+0x53/0x393
> Apr 24 09:01:00 thinpower [1349916.949967]  [<ffffffff81096702>]
> handle_mm_fault+0x36b/0x854
> Apr 24 09:01:00 thinpower [1349916.949971]  [<ffffffff8100cf6e>] ?
> apic_timer_interrupt+0xe/0x20
> Apr 24 09:01:00 thinpower [1349916.949974]  [<ffffffff81022c8f>] ?
> default_spin_lock_flags+0x9/0xe
> Apr 24 09:01:00 thinpower [1349916.949976]  [<ffffffff81022c8f>] ?
> default_spin_lock_flags+0x9/0xe
> Apr 24 09:01:00 thinpower [1349916.949981]  [<ffffffff814ac6fe>]
> do_page_fault+0x662/0xa5c
> Apr 24 09:01:00 thinpower [1349916.949985]  [<ffffffff813a1acb>] ?
> release_sock+0xb0/0xbb
> Apr 24 09:01:00 thinpower [1349916.949989]  [<ffffffff813e6628>] ?
> tcp_recvmsg+0x720/0x833
> Apr 24 09:01:00 thinpower [1349916.949991]  [<ffffffff813a0eb6>] ?
> sock_common_recvmsg+0x32/0x47
> Apr 24 09:01:00 thinpower [1349916.949995]  [<ffffffff81198a02>] ?
> selinux_socket_recvmsg+0x1d/0x1f
> Apr 24 09:01:00 thinpower [1349916.949999]  [<ffffffff8139ef03>] ?
> __sock_recvmsg+0x6d/0x79
> Apr 24 09:01:00 thinpower [1349916.950001]  [<ffffffff8139effd>] ?
> sock_aio_read+0xee/0xfe
> Apr 24 09:01:00 thinpower [1349916.950005]  [<ffffffff810b42b3>] ?
> do_sync_read+0xe7/0x12d
> Apr 24 09:01:00 thinpower [1349916.950008]  [<ffffffff813f22bd>] ?
> tcp_write_xmit+0x453/0x913
> 
