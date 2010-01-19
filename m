Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268Ab0ASJJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0ASJJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597Ab0ASJJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:09:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab0ASJI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:08:59 -0500
Message-ID: <4B55762F.7010204@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 17:06:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] perf_event: fix race in perf_swevent_get_recursion_context()
References: <4B54654A.4090601@cn.fujitsu.com>	 <4B5465D8.9070203@cn.fujitsu.com> <4B54662B.4050109@cn.fujitsu.com>	 <4B556F66.3070402@cn.fujitsu.com> <1263890793.4283.639.camel@laptop>
In-Reply-To: <1263890793.4283.639.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Tue, 2010-01-19 at 16:37 +0800, Xiao Guangrong wrote:
>> It only disable preemption in perf_swevent_get_recursion_context(),
>> it can't avoid race of hard-irq and NMI since they are nested that
>> will re-enter this path and make the recursion value chaotic
>>
>> In this patch, we use atomic operation to avoid it and reduce
>> cpu_ctx->recursion size, it also make this patch no need disable
>> preemption
> 
> NAK
> 

Sorry, i forget the nesting of hard-irq is sequential, and not pollute
recursion value, thanks for you point out.

Hi Ingo,

Please ignore this patch, it not pollute other 2 patches in this
patchset

Thanks,
Xiao
