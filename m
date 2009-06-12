Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbZFLHzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbZFLHzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZFLHzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:55:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:50132 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZFLHzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:55:04 -0400
Message-ID: <4A3209C6.1020604@oracle.com>
Date: Fri, 12 Jun 2009 15:54:46 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
References: <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>	<4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>	<20090608015242.GB2596@cr0.nay.redhat.com>	<4A2CA96D.3090502@oracle.com>	<2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>	<4A2CC52B.9010602@oracle.com>	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>	<m1ab4i11zx.fsf@fess.ebiederm.org>	<20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org>
In-Reply-To: <m11vpqvozl.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.4A3209CC.0082:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	sorry for the delay. I am occupied by other stuff these days.

I just tried and the strange thing is that 2 same boxes(Dell optiplex 
745) with 2.6.29 kernel have different output. One is normal and one is 
wrong. So I am totally puzzled now

So Eric may be right(there is a memory stomp), but it does show sometimes.

Regards,
Tao

Eric W. Biederman wrote:
> Amerigo Wang <xiyou.wangcong@gmail.com> writes:
> 
>> On Mon, Jun 08, 2009 at 09:10:10PM -0700, Eric W. Biederman wrote:
>>> Américo Wang <xiyou.wangcong@gmail.com> writes:
>>>
>>>> On Mon, Jun 8, 2009 at 4:00 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>>>>>> But the result is the same
>>>>>> Yes?
>>>>>> Your printk() shows kcore size is: 5301604352, and in your subject it is
>>>>>> 281474974617600...
>>>>>>
>>>>>> Or they happened in the same time?
>>>>> yes. the same box and the same linux version.
>>>>> A bit strange.
>>>>>
>>>>> [taoma@ocfs2-test2 ~]$ dmesg|grep "high memory"
>>>>> high memory ffff88013c000000, size 5301604352
>>>>> [taoma@ocfs2-test2 ~]$ ll /proc/kcore
>>>>> -r-------- 1 root root 281474974617600 Jun  8 15:20 /proc/kcore
>>>> Really weird...
>>>> They should be the same. This means we have some problem in our procfs.
>>>>
>>>> And, we have no problem on i386, I, myself, even can't reproduce this on my
>>>> x86_64 box...
>>>>
>>>> Drop Cc to x86 people, add some Cc to proc people. :)
>>>>
>>>> Eric, Alexey, any ideas?
>>>>
>>>> Tao, would you like to send us your .config? Thanks.
>>> Short of some strange patch applied I would guess that a non-sense /proc/kcore
>>> size is related to a kernel memory stomp, stepping on the high_memory variable.
>> Hello, Eric.
>>
>> I see the problem now, I think the documentation of /proc/kcore
>> is wrong, the size of kcore can be more than the size of physical
>> memory, because it also contains the info of kernel modules which
>> stay above the mapping of phy memory, see arch/x86/mm/init_64.c.
>>
>> What do you think?
> 
> I think that doesn't make any sense.
> 
> I was reading the code.
> 
> I smell a nasty problem somewhere.
> 
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
