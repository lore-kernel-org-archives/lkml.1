Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYGBIuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYGBIuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYGBIuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:50:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:11477 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYGBIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sL88GBLKP+Kkv88yWMiDwGfs+qkCdW0GKNMjRSbzNF5tS4ndieBsBOR8f5/fSBHnoR
         DyxZ9YWursmigVJGbBVu0qs8ZXPtzGpihhApDw1E1phJTx61CARssvbwOvo6+3fj/luJ
         aPAngUyfU3t5ePz3OxUc1nwXYmDG6HINj2yDE=
Message-ID: <b647ffbd0807020150y650c3172me64b70710a8158d7@mail.gmail.com>
Date: Wed, 2 Jul 2008 10:50:34 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [BUG] CFS vs cpu hotplug
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Avi Kivity" <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <486B2AB0.1080506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080619161949.GA11062@osiris.ibm.com>
	 <b647ffbd0806251512i3ab6efedv75a5bddd865ef618@mail.gmail.com>
	 <b647ffbd0806281516i57392230idf06f99ff02d22cf@mail.gmail.com>
	 <20080630090744.GB6598@osiris.boeblingen.de.ibm.com>
	 <20080630091711.GA26637@elte.hu> <4869F770.6050103@cn.fujitsu.com>
	 <20080701093124.GC31309@elte.hu> <486B2AB0.1080506@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/2 Lai Jiangshan <laijs@cn.fujitsu.com>:
> Ingo Molnar wrote:
>> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>>> The following oops still occurred whether this patch is applied or not.
>>
>>>  [<ffffffff8059372c>] notifier_call_chain+0x33/0x5b
>>>  [<ffffffff802476a9>] __raw_notifier_call_chain+0x9/0xb
>>>  [<ffffffff802476ba>] raw_notifier_call_chain+0xf/0x11
>>>  [<ffffffff805736d6>] _cpu_down+0x191/0x256
>>>  [<ffffffff805737c1>] cpu_down+0x26/0x36
>>>  [<ffffffff805749c1>] store_online+0x32/0x75
>>>  [<ffffffff803d1982>] sysdev_store+0x24/0x26
>>>  [<ffffffff802d2551>] sysfs_write_file+0xe0/0x11c
>>>  [<ffffffff80290e6b>] vfs_write+0xae/0x137
>>>  [<ffffffff802913d3>] sys_write+0x47/0x70
>>>  [<ffffffff8020b1eb>] system_call_after_swapgs+0x7b/0x80
>>
>> hm, there were multiple problems in this area and a lot of dormant bugs.
>> Do you have this recent upstream commit in your tree:
> Hi, Ingo
>        I tested it again with the most recent upstreams(including the
> following patch) committed, the oops still occurred.

[ taken from the oops ]
>
> kernel BUG at kernel/sched.c:6133!
>

is it BUG_ON(rq->nr_running != 0); in your sched.c?

hum, it's line #6134 in the recent sched.c version. So with the recent
version it was "kernel BUG at kernel/sched.c:6134!" right?

could you please try to get a crash with my additional debugging patch
(you may find it in this thread) applied?
We should see then all tasks that have been migrated (or failed to be
migrated) during migration_call(CPU_DEAD, ...).

TIA,

-- 
Best regards,
Dmitry Adamushko
