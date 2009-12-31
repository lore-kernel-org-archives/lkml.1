Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbZLaLcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbZLaLcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZLaLcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:32:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZLaLcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:32:00 -0500
Message-ID: <4B3C8B3C.7070400@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 19:30:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: adjust symbol address
References: <4B3AC5CD.1000502@cn.fujitsu.com> <4B3AC69F.4070901@cn.fujitsu.com> <20091230131016.GC2956@ghostprotocols.net> <4B3C1397.8040307@cn.fujitsu.com> <20091231102938.GD2384@ghostprotocols.net> <4B3C819D.9000809@cn.fujitsu.com> <20091231110843.GF2384@ghostprotocols.net>
In-Reply-To: <20091231110843.GF2384@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:
> Em Thu, Dec 31, 2009 at 06:49:01PM +0800, Xiao Guangrong escreveu:
>>
>> Arnaldo Carvalho de Melo wrote:
>>
>>>> vmlinux* not know it's relocation or not, and we just handle the _specific_
>>>> kernel at the time which match the current system. 
>>> 'perf record' in one machine + 'perf report' in another should be
>>> possible.
>>>  
>> Yeah, but current code not support this since it not record kernel build-id in
>> perf.data while 'perf record' works, maybe you can fix it.
> 
> Huh? Checking...
> 
> [root@ana tmp]# perf record -a -f sleep 1s
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 0.330 MB perf.data (~14404 samples) ]
> [root@ana tmp]# perf buildid-list | grep kallsyms
> a3301c8755357466e39d71b46e8f69aecf83c0e8 [kernel.kallsyms]
> a3301c8755357466e39d71b46e8f69aecf83c0e8 [kernel.kallsyms]
> [root@ana tmp]#
> 
> In fact there is a bug, but the bug is either in 'perf buildid-list'
> showing it twice or it being recorded twice in 'perf record'.
> 

Ah, it seems some perf tools like 'perf kmem/sched' not use the build-id which it's
recorded in perf.data and it use the current kernel's build-id:

perf kmem/sched -> perf_session__new() -> perf_session__create_kernel_maps() ->
map_groups__create_kernel_maps() -> dsos__create_kernel():

sysfs__read_build_id("/sys/kernel/notes", kernel->build_id,
				 sizeof(kernel->build_id)

Hope i not misunderstand it. :-)

Xiao
