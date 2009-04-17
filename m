Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbZDQJaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbZDQJaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759782AbZDQJ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:29:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759632AbZDQJ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:29:49 -0400
Message-ID: <49E84BF5.4070604@cn.fujitsu.com>
Date: Fri, 17 Apr 2009 17:29:25 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrea Righi <righi.andrea@gmail.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>	<1239740480-28125-2-git-send-email-righi.andrea@gmail.com>	<20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>	<49E8311D.5030901@cn.fujitsu.com> <20090417164351.ea85012d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090417164351.ea85012d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 17 Apr 2009 15:34:53 +0800
> Gui Jianfeng <guijianfeng@cn.fujitsu.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> On Tue, 14 Apr 2009 22:21:12 +0200
>>> Andrea Righi <righi.andrea@gmail.com> wrote:
>>>
>>>> +Example:
>>>> +* Create an association between an io-throttle group and a bio-cgroup group
>>>> +  with "bio" and "blockio" subsystems mounted in different mount points:
>>>> +  # mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
>>>> +  # cd /mnt/bio-cgroup/
>>>> +  # mkdir bio-grp
>>>> +  # cat bio-grp/bio.id
>>>> +  1
>>>> +  # mount -t cgroup -o blockio blockio /mnt/io-throttle
>>>> +  # cd /mnt/io-throttle
>>>> +  # mkdir foo
>>>> +  # echo 1 > foo/blockio.bio_id
>>> Why do we need multiple cgroups at once to track I/O ?
>>> Seems complicated to me.
>>   Hi Kamezawa-san,
>>
>>   The original thought to implement this function is for sharing a bio-cgroup
>>   with other subsystems, such as dm-ioband. If the bio-cgroup is already mounted,
>>   and used by dm-ioband or others, we just need to create a association between 
>>   io-throttle and bio-cgroup by echo a bio-cgroup id, just like what dm-ioband does.
>>
> 
> - Why we need multiple I/O controller ? 
> - Why bio-cgroup cannot be a _pure_ infrastructe as page_cgroup ?
> - Why we need extra mount ?
> 
> I have no answer but, IMHO, 
>  - only one I/O controller should be enabled at once.
>  - bio cgroup should be tightly coupled with I/O controller and should work as
>    infrastructure i.e. naming/tagging I/O should be automatically done by
>    I/O controller. not by the user's hand.

  It seems dm-ioband has to make use of bio-cgroup by the user's hand. Because dm-ioband
  is not cgroup based. :(

  Is that possible that another subsystem(not cgroup based, and not an IO Controller) also 
  would like to use bio-cgroup in the future? There's no such case at least now, so i don't 
  object to get rid of this part. :)

> 
> Thanks,
> -Kame
> 
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng

