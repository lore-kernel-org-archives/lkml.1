Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZFOOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZFOOKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZFOOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:10:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:34532 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZFOOKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:10:33 -0400
Message-ID: <4A36C6CA.9070507@oracle.com>
Date: Tue, 16 Jun 2009 06:10:18 +0800
From: TaoMa <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: ebiederm@xmission.com
CC: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
References: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>	<4A2CC52B.9010602@oracle.com>	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>	<m1ab4i11zx.fsf@fess.ebiederm.org>	<20090611050929.GA2706@cr0.nay.redhat.com>	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>	<m17hzg7oil.fsf@fess.ebiederm.org>	<20090615021457.GA3388@cr0.nay.redhat.com> <4A35E32C.30609@oracle.com>	<20090615070018.GD3544@cr0.nay.redhat.com>	<4A360793.6060000@oracle.com> <m1ski1g632.fsf@fess.ebiederm.org>
In-Reply-To: <m1ski1g632.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A36564E.0105:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com wrote:
> Tao Ma <tao.ma@oracle.com> writes:
>
>   
>> Hi Amerigo,
>>
>> The wrong number I mean is 131941393240064.
>>
>> So do you think
>> [root@test3 ~]# ls -l /proc/kcore
>> -r-------- 1 root root 131941393240064 Jun 15 13:39 /proc/kcore
>>
>> is better than
>>
>> [taoma@test2 ~]$ ll /proc/kcore
>> -r-------- 1 root root 281474974617600 Jun 15 15:20 /proc/kcore
>> ?
>>
>> I don't think so.
>>
>> Actually the right result should look like
>>
>> [root@test8 ~]# ls -l /proc/kcore
>> -r-------- 1 root root 5301604352 Jun 15 13:35 /proc/kcore
>>
>> And with your patch I can't get this number.
>>     
>
> Actually that value is the bug.  It has absolutely nothing
> to do with the offsets that are valid within /proc/kcore.
>
> Why do you prefer the smaller number?
>   
Amerigo said in the previous e-mail that " the man page for/proc/kcore 
is wrong, its size can be more than the physical memory size, because it 
also contains memory area of vmalloc(), vsyscall etc..."

I have 4G memory, and 5301604352 is just a bit larger than 4G and looks 
sane. So I misunderstand that this number is right.

But if it is also a bug, I am willing to test any of the new patch. ;)

Regards,
Tao
