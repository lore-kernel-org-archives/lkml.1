Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYILXEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYILXEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYILXEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:04:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:4848 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYILXEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sa8OpjdSkg02MQgU1g2jmDmvjNDmpTjVmukrPQZBtO0EtFkDTDBLf/CqyG5JlmFn3U
         zSt6gR9NjvqNmxLm/kULsTPy9e9y/v/MlLUkCTG83IFN8KL4Ry8bCjsTzsS1LVIsrSr6
         AX9wdOYEm2iG2tsjLmEuCcQw9CjcXlhADwLHw=
Message-ID: <48CAF583.8060406@gmail.com>
Date: Sat, 13 Sep 2008 01:04:35 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: balbir@linux.vnet.ibm.com, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com,
       chlunde@ping.uio.no, dpshah@google.com, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, agk@sourceware.org, m.innocenti@cineca.it,
       s-uchida@ap.jp.nec.com, ryov@valinux.co.jp, matt@bluehost.com,
       dradford@bluehost.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com> <20080912131816.e0cfac7a.akpm@linux-foundation.org>
In-Reply-To: <20080912131816.e0cfac7a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Sep 2008 17:09:50 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> The goal of the patch is to control how much dirty file pages a cgroup can have
>> at any given time (see also [1]).
>>
>> Dirty file and writeback pages are accounted for each cgroup using the memory
>> controller statistics. Moreover, the dirty_ratio parameter is added to the
>> memory controller. It contains, as a percentage of the cgroup memory, the
>> number of dirty pages at which the processes belonging to the cgroup which are
>> generating disk writes will start writing out dirty data.
>>
>> So, the behaviour is actually the same as the global dirty_ratio, except that
>> it works per cgroup.
>>
>> Interface:
>> - two new entries "writeback" and "filedirty" are added to the file
>>   memory.stat, to export to userspace respectively the number of pages under
>>   writeback and the number of dirty file pages in the cgroup
>>
>> - the new file memory.dirty_ratio is added in the cgroup filesystem to show/set
>>   the memcg dirty_ratio
> 
> Seems like a desirable objective.
> 
>> [ This patch is still experimental and I only did few quick tests. I'd like to
>> do run more detailed benchmarks and compare the results, I guess the overhead
>> introduced by this patch shouldn't be so small... and BTW I would prefer a
>> dirty limit in bytes, intead of using a percentage of memory. Bytes are hugely
>> more flexible IMHO, they allow to define more fine-grained limits and so this
>> would work better on large memory machines. ]
>>
>> [1] http://lkml.org/lkml/2008/9/9/245
> 
> I tend to duck experimental and rfc patches ;)
> 
> One thing to think about please: Michael Rubin is hitting problems with
> the existing /proc/sys/vm/dirty-ratio.  Its present granularity of 1%
> is just too coarse for really large machines, and as
> memory-size/disk-speed ratios continue to increase, this will just get
> worse.
> 
> So after thinking about it a bit I encouraged him to propose a patch
> which adds a new /proc/sys/vm/hires-dirty-ratio (for some value of
> "hires" ;)) which simply offers a higher-resolution interface to the
> same internal kernel machinery.
> 
> How does this affect you?  I don't think we should be adding new
> interfaces which have the old 1%-resolution problem.  Once we get this
> higher-resolution interface sorted out, your new interface should do it
> the same way.

Totally agree.

The hires-dirty-ratio interface seems much better. I'll follow the progresses
of this new interface, reusing the same way in my patch doesn't look too difficult,
in any case.

BTW why not use a simple dirty-ratio-in-bytes?

Thanks for commenting,
-Andrea
