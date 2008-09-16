Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYIPDcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYIPDcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 23:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYIPDcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 23:32:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYIPDcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 23:32:46 -0400
Message-ID: <48CF2863.1010502@cn.fujitsu.com>
Date: Tue, 16 Sep 2008 11:30:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] cgroup: use multibuf for tasks file
References: <48CA58A9.4010508@cn.fujitsu.com> <6599ad830809151328n98dcffdxee0977e781b138cd@mail.gmail.com> <48CF0DC4.8030402@cn.fujitsu.com> <48CF1710.20907@cn.fujitsu.com>
In-Reply-To: <48CF1710.20907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Lai Jiangshan wrote:
>> Paul Menage wrote:
>>> On Fri, Sep 12, 2008 at 4:55 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>>> when we open a really large cgroup for read, we may failed
>>>> for kmalloc() is not reliable for allocate a big buffer.
>>> This still depends on an answer to whether using plain vmalloc is too
>>> much overhead.
>>>
>>> Balbir pointed out to me that most cgroups are likely to be pretty
>>> small - so the solution of just doing a kmalloc() for 8K or less, and
>>> a vmalloc() for more than 8K (which is >2000 threads) will avoid the
>>> vmalloc overhead in almost all cases; the question is whether
>>> eliminating the remaining overhead is worth the extra complexity.
>>>
>> I think open cgroup.tasks to read is not a critical path.
>> so using plain vmalloc(even more overhead functions) is worth.
>>
> 
> This patch does not only add runtime overhead, but also make code much more
> complex, so the code is harder to read and harder to maintain, and object size
> is increased, which means increased memory footprint.
> 
> And is there any reason not using plain vmalloc? Don't bloat the kernel without
> good reasons IMO...
> 

I said that vmalloc is worth.
vmalloc was the fist choice of my opinion. ^_^

> 
> 


