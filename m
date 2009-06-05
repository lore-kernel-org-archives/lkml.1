Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZFEH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZFEH6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZFEH6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:58:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:32206 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZFEH6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X9KZXcxJL+3jJWzSOTwGgtoRDqjlW6U55RFkc5N+EUwlSYUwEgjjvjGINQ+elR1aHd
         33h8u0ZHlJ0D2o4eqoNq3H7I3/SH9TOmfXVWFkd1JPduVXxWIIhxE9RZrD5iLOw8YGm6
         +AtDhUeQt7LYDmTQpjU3v+BQiKzELF7u/LFRQ=
Date: Fri, 5 Jun 2009 16:00:19 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605080019.GD8171@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com> <20090605054902.GF7962@cr0.nay.redhat.com> <4A28B63E.1080004@oracle.com> <20090605064316.GB8171@cr0.nay.redhat.com> <4A28C1A4.9050708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28C1A4.9050708@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 02:56:36PM +0800, Tao Ma wrote:
>
>
> Amerigo Wang wrote:
>> On Fri, Jun 05, 2009 at 02:07:58PM +0800, Tao Ma wrote:
>>>
>>> Amerigo Wang wrote:
>>>> On Fri, Jun 05, 2009 at 12:03:52PM +0800, Tao Ma wrote:
>>>>> Hi list,
>>>>>       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable 
>>>>> large  to be 281474974617600.
>>>>> While in a x86 box, it is 931131392 which looks sane.
>>>>>
>>>>> [root@test8 ~]# ll /proc/kcore
>>>>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>>>>
>>>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>>>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>>> Hmm, what is your physical RAM size on test8?
>>>> /proc/kcore looks fine on my x86_64 box.
>>> Only 4G.
>>
>> Hmm, my x86_box has 8G mem, the size of kcore looks much
>> saner than the above huge number, but it is still wrong
>> according to what the man page describes...
>>
>> Please do what Andrew said, it will be helpful.
>>
>>>>> I just noticed this when kexec fails in "Can't find kernel text 
>>>>> map area  from kcore".
>>>>>
>>>>> Is there something wrong?
>>>> It looks like that error message is from userspace?
>>> I just started kdump and get the error message.
>>
>> IIRC, kdump should use /proc/vmcore, instead of /proc/kcore...
>> nothing related.
> in el5, when start kdump service it will do something like
> /sbin/kexec --args-linux -p '--command-line=ro root=LABEL=/ rhgb quiet  
> irqpoll maxcpus=1' --initrd=/boot/initrd-2.6.18-53.el5kdump.img  
> /boot/vmlinuz-2.6.18-53.el5
>
> And the error message is from there.

>From /sbin/kexec? I just checked the source code of kexec-tools,
I haven't found that message...
