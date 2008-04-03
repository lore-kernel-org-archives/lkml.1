Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYDCClW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYDCClW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759147AbYDCClN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:41:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759011AbYDCClM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:41:12 -0400
Message-ID: <47F4434D.9030800@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 10:39:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
CC: "'Paul Menage'" <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, axboe@kernel.dk,
       tom-sugawara@ap.jp.nec.com, m-takahashi@ex.jp.nec.com
Subject: Re: [RFC][patch 3/11][CFQ-cgroup] Introduce cgroup subsystem
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>	 <008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com> <6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <003001c89532$dae5dd20$90b19760$@jp.nec.com>
In-Reply-To: <003001c89532$dae5dd20$90b19760$@jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoshi UCHIDA wrote:
> Thank you for reply.
> 
>>>  +
>>>  +static struct cgroup_subsys_state *
>>>  +cfq_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>>>  +{
>>>  +       struct cfq_cgroup *cfqc;
>>>  +
>>>  +       if (!capable(CAP_SYS_ADMIN))
>>>  +               return ERR_PTR(-EPERM);
>>>  +
>>>  +       if (!cgroup_is_descendant(cont))
>>>  +               return ERR_PTR(-EPERM);
>> What are these checks for? Cgroups already provides filesystem
>> permissions to control directory creation, and the "descendant" check
>> looks like it may have been cut/pasted from the nsproxy subsystem.
>>
> 
> This code was referred one of io-throttle.
> Is it not necessary these checks?
> IF not necessary, remove this code.
> 
>>>   /* */
>>>  +
>>>  +#ifdef CONFIG_CGROUP_CFQ
>>>  +SUBSYS(cfq_cgroup)
>>>  +#endif
>>>  +
>>>  +/* */
>> To fit with the convention for other subsystems, simply "cfq" would be
>> a better name than "cfq_cgroup". (Clearly it's a cgroup subsystem from
>> context).
>>
> 
> Ok, I change name.
> I hesitated whether using "_cgroup".
> The cpuset and the cpuacct does not use it,
> but cpu and memory uses it(cpu_cgroup and mem_cgroup).
> In this patchset, I select the latter case.
> 

+struct cgroup_subsys cfq_cgroup_subsys = {
+	.name = "cfq_cgroup",
+	...
+};

but memory controller has the name 'memory', similar for cgroup sched.

So we do this:
	mount -t cgroup -omemory xxx /dev/memcg
but not:
	mount -t cgroup -omemory_cgroup xxx /dev/memcg
