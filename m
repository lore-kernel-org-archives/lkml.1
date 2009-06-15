Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZFPCFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZFPCFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZFPCFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:05:17 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:51080 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZFPCFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:05:15 -0400
Message-ID: <4A367E6C.6030308@oracle.com>
Date: Tue, 16 Jun 2009 01:01:32 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>	<4A2CC52B.9010602@oracle.com>	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>	<m1ab4i11zx.fsf@fess.ebiederm.org>	<20090611050929.GA2706@cr0.nay.redhat.com>	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>	<m17hzg7oil.fsf@fess.ebiederm.org>	<20090615021457.GA3388@cr0.nay.redhat.com> <4A35E32C.30609@oracle.com>	<20090615070018.GD3544@cr0.nay.redhat.com>	<4A360793.6060000@oracle.com> <m1ski1g632.fsf@fess.ebiederm.org>	<4A36C6CA.9070507@oracle.com> <m1eitl8eiq.fsf@fess.ebiederm.org>
In-Reply-To: <m1eitl8eiq.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A36FDCD.000D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



ebiederm@xmission.com wrote:
> TaoMa <tao.ma@oracle.com> writes:
> 
>> ebiederm@xmission.com wrote:
>>> Tao Ma <tao.ma@oracle.com> writes:
>>>
>>>   
>>>> Hi Amerigo,
>>>>
>>>> The wrong number I mean is 131941393240064.
>>>>
>>>> So do you think
>>>> [root@test3 ~]# ls -l /proc/kcore
>>>> -r-------- 1 root root 131941393240064 Jun 15 13:39 /proc/kcore
>>>>
>>>> is better than
>>>>
>>>> [taoma@test2 ~]$ ll /proc/kcore
>>>> -r-------- 1 root root 281474974617600 Jun 15 15:20 /proc/kcore
>>>> ?
>>>>
>>>> I don't think so.
>>>>
>>>> Actually the right result should look like
>>>>
>>>> [root@test8 ~]# ls -l /proc/kcore
>>>> -r-------- 1 root root 5301604352 Jun 15 13:35 /proc/kcore
>>>>
>>>> And with your patch I can't get this number.
>>>>     
>>> Actually that value is the bug.  It has absolutely nothing
>>> to do with the offsets that are valid within /proc/kcore.
>>>
>>> Why do you prefer the smaller number?
>>>   
>> Amerigo said in the previous e-mail that " the man page for/proc/kcore is wrong,
>> its size can be more than the physical memory size, because it also contains
>> memory area of vmalloc(), vsyscall etc..."
>>
>> I have 4G memory, and 5301604352 is just a bit larger than 4G and looks sane. So
>> I misunderstand that this number is right.
> 
> It should also include the 32 Tebibyte range we have for vmalloc.  So
> a completely dense encoding would be a bit larger than 35184372088832
> bytes.  You can see that range in your readelf -l output.
> 
> Since the encoding is not dense the size actually comes to. 256TiB.
> Or roughly 281474976710656 bytes.
> 
>> But if it is also a bug, I am willing to test any of the new patch. ;)
> 
> Not in the sense that anything could go wrong.  Merely in the sense that
> we have a contradictory definition.  Which causes loads of confusion.
> 
> I am wondering if this difference in definition has caused any
> problems applications to fail or if this just started out as an
> observation of an anomaly?
I first noticed it when my el5 box refused to start kdump service and 
kexec said something like "Can't find kernel text map area from kcore". 
And then I found this number which looked a bit strange.
I also just have another x86 box and "ls -l /proc/kcore" shows:
-r-------- 1 root root 939528192 Jun 16 10:01 /proc/kcore
So I thought this may be a bug and started this thread.

Anyway, later I found that kexec's problem isn't related to this issue.
So maybe we can leave as-is.

regards,
Tao
