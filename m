Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZFEJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZFEJRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZFEJRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:17:30 -0400
Received: from mail-qy0-f176.google.com ([209.85.221.176]:58844 "EHLO
	mail-qy0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFEJR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:17:29 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jun 2009 05:17:29 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hsUiw+se+AwWol8MG66Kag8RHry6T7Eemo+J/hgAg5tfalRMc+uedbhRwwlSCvC1of
         rYITu5QJi/4+YIzFvsfRZs+X8h/EOXKn+hfwU5eLfovkYu2vEGwQTVy3yV6pGCMimeno
         57RzbfSIxJr5P+cn/qV2qbBkXeWuP7LUav6Ic=
MIME-Version: 1.0
In-Reply-To: <4A28DDEB.4000409@oracle.com>
References: <4A289928.7040508@oracle.com>
	 <20090604223805.2962e826.akpm@linux-foundation.org>
	 <4A28C262.5020605@oracle.com>
	 <20090605075614.GC8171@cr0.nay.redhat.com>
	 <4A28DDEB.4000409@oracle.com>
Date: Fri, 5 Jun 2009 17:09:54 +0800
Message-ID: <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64 
	2.6.30-rc8.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some Cc: to x86 people. :)

Yinghai?

On Fri, Jun 5, 2009 at 4:57 PM, Tao Ma<tao.ma@oracle.com> wrote:
>
>
> Amerigo Wang wrote:
>>
>> On Fri, Jun 05, 2009 at 02:59:46PM +0800, Tao Ma wrote:
>>>
>>> Andrew Morton wrote:
>>>>
>>>> On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:
>>>>
>>>>> Hi list,
>>>>>       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large
>>>>> to be 281474974617600.
>>>>> While in a x86 box, it is 931131392 which looks sane.
>>>>>
>>>>> [root@test8 ~]# ll /proc/kcore
>>>>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>>>>
>>>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>>>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>>>>
>>>>> I just noticed this when kexec fails in "Can't find kernel text map
>>>>> area from kcore".
>>>>>
>>>>> Is there something wrong?
>>>>>
>>>> fs/proc/kcore.c hasn't changed since October last year.  Was 2.6.29 OK?
>>>> Earlier kernels?
>>>
>>> with 2.6.29, ls shows the same output.
>>> [root@test8 ~]# ll /proc/kcore
>>> -r-------- 1 root root 281474974617600 Jun  5 14:35 /proc/kcore
>>
>>
>> Thanks.
>>
>> It looks like the value of 'high_memory' is insane..
>> Can you get its value on your machine? You can add a printk() or use
>> systemtap etc..
>
> Just did that.
> Also a strange number.
> high memory 18446612137615818752.
>
> Regards,
> Tao
>
