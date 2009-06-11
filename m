Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZFKFHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZFKFHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZFKFG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:06:57 -0400
Received: from mail-pz0-f172.google.com ([209.85.222.172]:53278 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbZFKFG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ehtwa9uTj4qwsxvBqM01WDNkw3IDI6rEtagva7AQau0Tv2mxRu0I0va/F84mo4jSZs
         WSHK9IcOOn+8n9trWLpauymr82ugOn/l32x+thxdx9aYDmCtVn4XQaQbTA0zR+IFwIE6
         7sD4Wl1D16xc2Izw7gOavuh9CyFm6Egg9QOhY=
Date: Thu, 11 Jun 2009 13:09:29 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090611050929.GA2706@cr0.nay.redhat.com>
References: <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org> <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org> <20090608015242.GB2596@cr0.nay.redhat.com> <4A2CA96D.3090502@oracle.com> <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1ab4i11zx.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:10:10PM -0700, Eric W. Biederman wrote:
>Américo Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Mon, Jun 8, 2009 at 4:00 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>>>>
>>>>> But the result is the same
>>>>
>>>> Yes?
>>>> Your printk() shows kcore size is: 5301604352, and in your subject it is
>>>> 281474974617600...
>>>>
>>>> Or they happened in the same time?
>>>
>>> yes. the same box and the same linux version.
>>> A bit strange.
>>>
>>> [taoma@ocfs2-test2 ~]$ dmesg|grep "high memory"
>>> high memory ffff88013c000000, size 5301604352
>>> [taoma@ocfs2-test2 ~]$ ll /proc/kcore
>>> -r-------- 1 root root 281474974617600 Jun  8 15:20 /proc/kcore
>>
>> Really weird...
>> They should be the same. This means we have some problem in our procfs.
>>
>> And, we have no problem on i386, I, myself, even can't reproduce this on my
>> x86_64 box...
>>
>> Drop Cc to x86 people, add some Cc to proc people. :)
>>
>> Eric, Alexey, any ideas?
>>
>> Tao, would you like to send us your .config? Thanks.
>
>Short of some strange patch applied I would guess that a non-sense /proc/kcore
>size is related to a kernel memory stomp, stepping on the high_memory variable.

Hello, Eric.

I see the problem now, I think the documentation of /proc/kcore
is wrong, the size of kcore can be more than the size of physical
memory, because it also contains the info of kernel modules which
stay above the mapping of phy memory, see arch/x86/mm/init_64.c.

What do you think?

Thanks!

