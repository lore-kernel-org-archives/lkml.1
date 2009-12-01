Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZLADDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZLADDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 22:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZLADDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 22:03:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZLADDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 22:03:30 -0500
Message-ID: <4B14868F.7080609@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 10:59:27 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: Re: [RFC] Block IO Controller V3
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com> <4B137470.3000601@cn.fujitsu.com> <20091130171347.GH11670@redhat.com>
In-Reply-To: <20091130171347.GH11670@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Nov 30, 2009 at 03:29:52PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> Hi Jens,
>>>
>>> This is V3 of the Block IO controller patches on top of "for-2.6.33" branch
>>> of block tree.
>>>
>> ...
>>
>> Hi Vivek,
>>
>> If an idle task is running group A and a normal task is running in group B, these
>> two group have the same weight, I think IO Controller should isolate group A and
>> group B, these two group should get 50% of the IO bw for each, right? But for this case,
>> we don't see any isolation, instead, group B monopolizes almost all IO BW. I guess
>> the major reason is idle cfqq is only allowed to dispatch one request and get expired.
>> I think in order to get better isolation, we shouldn't expire the idle cfqq immediately
>> if this idle queue is the only one this its group. The following patch enable idling
>> for idle queue and prevent expiring it immediately after dispatch one request if it's 
>> the only one in group. This patch is working for V3, hasn't tested on V4 yet.
>>
> 
> Hi Gui,
> 
> Thanks for the patch. I have intentionally kept idle queue make dispatch
> one request at a time system wide irrespective of group.
> 
> What's the use case scenario of enforcing idle dispatch more based on
> group weight. If somebody has marked a queue idle, he is not expecting
> much of that queue anyway.

  IMHO, If somebody decide to put an idle task into a group, i think he
  should know what will happen(isolation thing).

> 
> Now one can argue that for better isolation, don't make idle class system
> wide and an idle task should get more disk time if there are no other
> queues with-in group.
> 
> So for the time being I will leave as it is. We can fix this once somebody
> needs stronger isolation even for idle tasks.
> 

So, maybe we can rely on group_isolation tunable, when group_isolation == 1, 
we provide isolation for idle queues.

