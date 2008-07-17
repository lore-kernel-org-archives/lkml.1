Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYGQKPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYGQKPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGQKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:14:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYGQKO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:14:59 -0400
Message-ID: <487F1B38.3050100@cn.fujitsu.com>
Date: Thu, 17 Jul 2008 18:13:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Paul Jackson <pj@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain level
References: <487EFDD0.2060101@cn.fujitsu.com> <487F0996.9010904@jp.fujitsu.com>
In-Reply-To: <487F0996.9010904@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Li Zefan wrote:
>> When multiple cpusets are overlapping in their 'cpus' and hence they
>> form a single sched domain, the largest sched_relax_domain_level among
>> those should be used. But when top_cpuset's sched_load_balance is
>> set, its sched_relax_domain_level is used regardless other sub-cpusets'.
>>
>> There are several proposals to solve this:
>>
>> 1) Travel the cpuset hierarchy to find the largest relax_domain_level
>>    in rebuild_sched_domains(). But cpuset avoids hierarchy travelling
>>    when top_cpuset.sched_load_balance is set.
>>
>> 2) Remember the largest relax_domain_level when we update a cpuset's
>>    sched_load_balance, sched_relax_domain_level and cpus. This should
>>    work, but seems a bit tricky and a bit ugly. (As this patch shows)
>>
>> 3) Don't treat this as a bug, but document this behavior.
> 
> I think 1) is correct way.
> 
> There was a special short path for the top_cpuset's case, but now it is
> disappeared. I think there are no need to treat the top_cpuset as VIP,
> so 2) is excessive nurturing.
> 

If we all agree on this, I'll send a new patch to fix this.


