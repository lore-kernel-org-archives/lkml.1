Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbYITFUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbYITFUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 01:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYITFTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 01:19:52 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37798 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYITFTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 01:19:51 -0400
Message-ID: <48D48789.8000606@linux.vnet.ibm.com>
Date: Fri, 19 Sep 2008 22:18:01 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Hirokazu Takahashi <taka@valinux.co.jp>, righi.andrea@gmail.com,
       dm-devel@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, agk@sourceware.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       jens.axboe@oracle.com, fernando@oss.ntt.co.jp, xemul@openvz.org
Subject: Re: [dm-devel] Re: dm-ioband + bio-cgroup benchmarks
References: <48D267B5.20402@gmail.com> <20080918150634.GH20640@redhat.com> <48D2715A.6060002@gmail.com> <20080919.123405.91829935.taka@valinux.co.jp> <20080920132703.e74c8f89.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080920132703.e74c8f89.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 19 Sep 2008 12:34:05 +0900 (JST)
> Hirokazu Takahashi <taka@valinux.co.jp> wrote:
> 
>> I've decided to get Ryo to post the accurate dirty-page tracking patch
>> for bio-cgroup, which isn't perfect yet though. The memory controller
>> never wants to support this tracking because migrating a page between
>> memory cgroups is really heavy.
>>
>> I also thought enhancing the memory controller would be good enough,
>> but a lot of people said they wanted to control memory resource and
>> block I/O resource separately.
>> So you can create several bio-cgroup in one memory-cgroup,
>> or you can use bio-cgroup without memory-cgroup.
>>
>> I also have a plan to implement more acurate tracking mechanism
>> on bio-cgroup after the memory cgroup team re-implement the infrastructure,
>> which won't be supported by memory-cgroup.
>> When a process are moved into another memory cgroup,
>> the pages belonging to the process don't move to the new cgroup
>> because migrating pages is so heavy. It's hard to find the pages
>> from the process and migrating pages may cause some memory pressure.
>> I'll implement this feature only on bio-cgroup with minimum overhead
>>
> I really would like to move page_cgroup to new cgroup when the process moves...
> But it's just in my plan and I'm not sure I can do it or not.
> 

Kamezawa-San, I am not dead against it, but I would provide a knob/control point
for system administrator to decide if movement is important for applications,
then let them do so (like force_empty).

> Anyway what's next for me is
>  1. fix current discussion to remove page->page_cgroup pointer.
>  2. reduce locks.

Are you planning on reposting these. I've been trying other approaches at my end

1. Use radix tree per-node per-zone
2. Use radix trees only for 32 bit systems
3. Depend on CONFIG_HAVE_MEMORY_PRESENT and build a sparse data structure and
use pre-allocation

I've posted (1) and I'll take a look at your patches as well

>  3. support swap and swap-cache.
> 
> I think algorithm for (1), (2) is now getting smart.
> 

Yes, it is getting better

> Thanks,
> -Kame
> 


-- 
	Balbir
