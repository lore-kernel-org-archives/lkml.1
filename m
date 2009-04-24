Return-Path: <linux-kernel-owner+w=401wt.eu-S1761068AbZDXSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbZDXSYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZDXSYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:24:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:63660 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZDXSYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hmq7NRYPPUaN7u1UjgQbdb8NOciduEGNLdZd4QDu9Wm4SywARRJi36k2SNrNXy/Fbe
         Ctytr17Y43y66HgpVmYdfvj3miMQ3UccAx8xRlJhEyhlXkgnJI2Me3xJccVEpZC8mc5H
         7A6bLL+IIXhB45EUBxTsOElRlXknYoln0SvfU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com>
	 <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com>
Date: Fri, 24 Apr 2009 20:24:08 +0200
Message-ID: <40a4ed590904241124m2f5eb1e9gb6b43a4012fcda36@mail.gmail.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
From: Zeno Davatz <zdavatz@gmail.com>
To: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Cc: Hannes Wyss <hwyss@ywesee.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 7:17 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 24 Apr 2009, Zeno Davatz wrote:
>
>> Dear All
>>
>> Our Kernel-Version:
>>
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
>
> If this is reproducible, I'd recommend enabling
> /proc/sys/vm/oom_dump_tasks so that the oom killer will dump the tasklist
> and show us what may be causing the livelock.

Ok, I believe I enabled it with

echo 1 > /proc/sys/vm/oom_dump_tasks

Where would I find the output if it livelocks again?

Thank you for your Feedback.

Best
Zeno
