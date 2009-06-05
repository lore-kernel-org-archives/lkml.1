Return-Path: <linux-kernel-owner+w=401wt.eu-S1750745AbZFEJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750745AbZFEJBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZFEJBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:01:07 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19381 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZFEJBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:01:06 -0400
Message-ID: <4A28DECC.8040804@oracle.com>
Date: Fri, 05 Jun 2009 17:01:00 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
References: <4A289928.7040508@oracle.com> <20090605054902.GF7962@cr0.nay.redhat.com> <4A28B63E.1080004@oracle.com> <20090605064316.GB8171@cr0.nay.redhat.com> <4A28C1A4.9050708@oracle.com> <20090605080019.GD8171@cr0.nay.redhat.com>
In-Reply-To: <20090605080019.GD8171@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A28DECF.0261:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Amerigo Wang wrote:
> On Fri, Jun 05, 2009 at 02:56:36PM +0800, Tao Ma wrote:
>>
>> Amerigo Wang wrote:
>>> On Fri, Jun 05, 2009 at 02:07:58PM +0800, Tao Ma wrote:
>>>> Amerigo Wang wrote:
>>>>> On Fri, Jun 05, 2009 at 12:03:52PM +0800, Tao Ma wrote:
>>>>>> Hi list,
>>>>>>       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable 
>>>>>> large  to be 281474974617600.
>>>>>> While in a x86 box, it is 931131392 which looks sane.
>>>>>>
>>>>>> [root@test8 ~]# ll /proc/kcore
>>>>>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>>>>>
>>>>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>>>>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>>>> Hmm, what is your physical RAM size on test8?
>>>>> /proc/kcore looks fine on my x86_64 box.
>>>> Only 4G.
>>> Hmm, my x86_box has 8G mem, the size of kcore looks much
>>> saner than the above huge number, but it is still wrong
>>> according to what the man page describes...
>>>
>>> Please do what Andrew said, it will be helpful.
>>>
>>>>>> I just noticed this when kexec fails in "Can't find kernel text 
>>>>>> map area  from kcore".
>>>>>>
>>>>>> Is there something wrong?
>>>>> It looks like that error message is from userspace?
>>>> I just started kdump and get the error message.
>>> IIRC, kdump should use /proc/vmcore, instead of /proc/kcore...
>>> nothing related.
>> in el5, when start kdump service it will do something like
>> /sbin/kexec --args-linux -p '--command-line=ro root=LABEL=/ rhgb quiet  
>> irqpoll maxcpus=1' --initrd=/boot/initrd-2.6.18-53.el5kdump.img  
>> /boot/vmlinuz-2.6.18-53.el5
>>
>> And the error message is from there.
> 
>>From /sbin/kexec? I just checked the source code of kexec-tools,
> I haven't found that message...
No, it is there.
See kexec-tools-1.101-reloc-update.patch.
src rpm is kexec-tools-1.101-194.4.el5.src.rpm. So it is a patch from el5.

Regards,
Tao
