Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZGNHih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZGNHih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 03:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZGNHig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 03:38:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50838 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZGNHig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 03:38:36 -0400
Message-ID: <4A5C35D7.1040502@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 15:37:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH] io-controller: implement per group request allocation
 limitation
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A569FC5.7090801@cn.fujitsu.com> <20090713160352.GA3714@redhat.com>
In-Reply-To: <20090713160352.GA3714@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Jul 10, 2009 at 09:56:21AM +0800, Gui Jianfeng wrote:
>> Hi Vivek,
>>
>> This patch exports a cgroup based per group request limits interface.
>> and removes the global one. Now we can use this interface to perform
>> different request allocation limitation for different groups. 
>>
> 
> Thanks Gui. Few points come to mind.
> 
> - You seem to be making this as per cgroup limit on all devices. I guess
>   that different devices in the system can have different settings of
>   q->nr_requests and hence will probably want different per group limit.
>   So we might have to make it per cgroup per device limit.

  Yes, per cgroup per device limitation seems more reasonable. I'll see what
  i can do.

> 
> - There does not seem to be any checks for making sure that children
>   cgroups don't have more request descriptors allocated than parent group.

  Do we really need to make it hierarchical? IMHO, maintaining this limitation
  for cgroups independently is enough.

> 
> - I am re-thinking that what's the advantage of configuring request
>   descriptors also through cgroups. It does bring in additional complexity
>   with it and it should justfiy the advantages. Can you think of some?

  I'll try, but at least, this feature lets us be able to do more accurate
  limitation. :)

> 
>   Until and unless we can come up with some significant advantages, I will
>   prefer to continue to use per group limit through q->nr_group_requests
>   interface instead of cgroup. Once things stablize, we can revisit it and
>   see how this interface can be improved.

  I agree.

-- 
Regards
Gui Jianfeng

