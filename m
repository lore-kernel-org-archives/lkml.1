Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZFHICi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZFHICi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbZFHICX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:02:23 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:61721 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZFHICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:02:22 -0400
Message-ID: <4A2CC52B.9010602@oracle.com>
Date: Mon, 08 Jun 2009 16:00:43 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 	2.6.30-rc8.
References: <20090605075614.GC8171@cr0.nay.redhat.com>	 <20090605021424.ba352b0f.akpm@linux-foundation.org>	 <4A28E5C9.6010408@oracle.com>	 <20090605095155.GC8354@cr0.nay.redhat.com>	 <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>	 <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>	 <20090608015242.GB2596@cr0.nay.redhat.com>	 <4A2CA96D.3090502@oracle.com> <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
In-Reply-To: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4A2CC52F.0116:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Américo Wang wrote:
> On Mon, Jun 8, 2009 at 2:02 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>
>> Amerigo Wang wrote:
>>> On Sat, Jun 06, 2009 at 03:21:23PM -0700, Yinghai Lu wrote:
>>>> Tao Ma wrote:
>>>>> Yinghai Lu wrote:
>>>>>> Tao Ma wrote:
>>>>>>> Amerigo Wang wrote:
>>>>>>>> On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>>>>>>>>> Please send the boot logs: dmesg -s 1000000 > foo
>>>>>>>>> attached.
>>>>>>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>>>>>>> #######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
>>>>>>>> These two lines must be added by yourself...
>>>>>>>>
>>>>>>>> What?!
>>>>>>>> How can PAGE_OFFSET be 0??
>>>>>>>> Can you show us these two printk() you just added?
>>>>>>>>
>>>>>>>> And, the size of kcore is not the crazy number in the subject...
>>>>>>>> This one is much saner..
>>>>>>> Sorry, I used the wrong printk. the correct one is:
>>>>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>>>>> #######kcore size 5301604352, PAGE_OFFSET 18446612132314218496,
>>>>>>> PAGE_SIZE 4096
>>>>>>>
>>>>>> %lx should be used.
>>>>>>
>>>>>> also you compiler doesn't like
>>>>>>
>>>>>> high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>>>>>>
>>>>>> in setup.c?
>>>>> Sorry fo my poor English, bug what do you mean?
>>>>>
>>>>> I just printk in the setup.c and the result is
>>>>>
>>>>> @@@@high_momory ffff88013c000000
>>>> so that value print out is right.
>>> Yeah.
>>>
>>> Tao, can you reproduce the number mentioned in the subject??
>> Sorry for the delay.
>>
>> But the result is the same
> 
> Yes?
> Your printk() shows kcore size is: 5301604352, and in your subject it is
> 281474974617600...
> 
> Or they happened in the same time?
yes. the same box and the same linux version.
A bit strange.

[taoma@ocfs2-test2 ~]$ dmesg|grep "high memory"
high memory ffff88013c000000, size 5301604352
[taoma@ocfs2-test2 ~]$ ll /proc/kcore
-r-------- 1 root root 281474974617600 Jun  8 15:20 /proc/kcore


Regards,
Tao
