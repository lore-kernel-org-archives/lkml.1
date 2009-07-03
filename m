Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbZGCBvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbZGCBvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZGCBu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:50:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56770 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZGCBuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:50:55 -0400
Message-ID: <4A4D6439.8030302@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 09:51:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>	 <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>	 <20090702112814.ddf0c280.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830907011949h13598e36m45b85ae76900b90a@mail.gmail.com>
In-Reply-To: <6599ad830907011949h13598e36m45b85ae76900b90a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  /*
>>>   * A cgroupfs_root represents the root of a cgroup hierarchy,
>>>   * and may be associated with a superblock to form an active
>>> @@ -93,6 +95,9 @@ struct cgroupfs_root {
>>>
>>>       /* The path to use for release notifications. */
>>>       char release_agent_path[PATH_MAX];
>>> +
>>> +     /* The name for this hierarchy - may be empty */
>>> +     char name[MAX_CGROUP_ROOT_NAMELEN];
>>>  };
>>>
>> If you don't want to make cgroupfs_root bigger,
>>
>>        cgroupfs_root {
>>                ......
>>                /* this must be the bottom of struct */
>>                char name[0];
>>        }
>>
>> Is a choice.
> 
> I'd rather avoid something like that since I think it's less readable
> - I'd probably just make the name into a pointer in that case.
> 

Whichever choice we make, the length should be limited I think.

>> BTW, reading a patch, any kind of charactors are allowed ?
> 
> Yes, other than \000 of course. I guess maybe I should use
> seq_escape() to print the name to avoid confusion in the event that
> people put whitespace in there, or else just ban whitespace (or maybe
> all non-alphanumeric chars).
> 

I don't think we need to care about this.

mount -t cgroup -o debug xxx /mnt

"xxx" can be any chars.


