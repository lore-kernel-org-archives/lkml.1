Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYIPCRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYIPCRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 22:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbYIPCRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 22:17:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbYIPCRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 22:17:35 -0400
Message-ID: <48CF1710.20907@cn.fujitsu.com>
Date: Tue, 16 Sep 2008 10:16:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] cgroup: use multibuf for tasks file
References: <48CA58A9.4010508@cn.fujitsu.com> <6599ad830809151328n98dcffdxee0977e781b138cd@mail.gmail.com> <48CF0DC4.8030402@cn.fujitsu.com>
In-Reply-To: <48CF0DC4.8030402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Paul Menage wrote:
>> On Fri, Sep 12, 2008 at 4:55 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>> when we open a really large cgroup for read, we may failed
>>> for kmalloc() is not reliable for allocate a big buffer.
>> This still depends on an answer to whether using plain vmalloc is too
>> much overhead.
>>
>> Balbir pointed out to me that most cgroups are likely to be pretty
>> small - so the solution of just doing a kmalloc() for 8K or less, and
>> a vmalloc() for more than 8K (which is >2000 threads) will avoid the
>> vmalloc overhead in almost all cases; the question is whether
>> eliminating the remaining overhead is worth the extra complexity.
>>
> 
> I think open cgroup.tasks to read is not a critical path.
> so using plain vmalloc(even more overhead functions) is worth.
> 

This patch does not only add runtime overhead, but also make code much more
complex, so the code is harder to read and harder to maintain, and object size
is increased, which means increased memory footprint.

And is there any reason not using plain vmalloc? Don't bloat the kernel without
good reasons IMO...
