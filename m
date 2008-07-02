Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYGBJZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYGBJZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYGBJZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:25:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51482 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYGBJZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:25:29 -0400
Message-ID: <486B490C.3090902@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 17:23:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
References: <20080619161949.GA11062@osiris.ibm.com>	 <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>	 <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>	 <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>	 <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com>	 <20080701093124.GC31309@elte.hu> <486B2AB0.1080506@cn.fujitsu.com> <b647ffbd0807020150y650c3172me64b70710a8158d7@mail.gmail.com>
In-Reply-To: <b647ffbd0807020150y650c3172me64b70710a8158d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/2 Lai Jiangshan <laijs@cn.fujitsu.com>:
>> Ingo Molnar wrote:
>>> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>>
>>>> The following oops still occurred whether this patch is applied or not.
>>>>  [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
>>>>  [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
>>>>  [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
>>>>  [<ffffffff805736d6>] _cpu_down+0x191/0x256
>>>>  [<ffffffff805737c1>] cpu_down+0x26/0x36
>>>>  [<ffffffff805749c1>] store_online+0x32/0x75
>>>>  [<ffffffff803d1982>] sysdev_store+0x24/0x26
>>>>  [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
>>>>  [<ffffffff80290e6b>] vfs_write+0xae/0x137
>>>>  [<ffffffff802913d3>] sys_write+0x47/0x70
>>>>  [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80
>>> hm, there were multiple problems in this area and a lot of dormant bugs.
>>> Do you have this recent upstream commit in your tree:
>> Hi, Ingo
>>        I tested it again with the most recent upstreams(including the
>> following patch) committed, the oops still occurred.
> 
> [ taken from the oops ]
>> kernel BUG at kernel/sched.c:6133!
>>
> 
> is it BUG_ON(rq->nr_running != 0); in your sched.c?
yes, I had test it twice yesterday, applied/not applied
your patch(no debugging).
> 
> hum, it's line #6134 in the recent sched.c version. So with the recent
> version it was "kernel BUG at kernel/sched.c:6134!" right?
yes, and applied your's and Zhang's patch as Ingo's advice.
> 
> could you please try to get a crash with my additional debugging patch
> (you may find it in this thread) applied?
> We should see then all tasks that have been migrated (or failed to be
> migrated) during migration_call(CPU_DEAD, ...).
>
Thank you. I'll test it again with your debugging patch applied
and get more info.
> TIA,
> 



