Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbYKQDrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbYKQDrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbYKQDrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:47:32 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34867 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbYKQDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:47:31 -0500
Message-ID: <4920E869.9030501@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 09:13:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max
 pages
References: <20081113171208.6985638e@bree.surriel.com> <20081116163316.F205.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081117093832.f383bd61.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081117093832.f383bd61.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 16 Nov 2008 16:38:56 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>> One more point.
>>
>>> Sometimes the VM spends the first few priority rounds rotating back
>>> referenced pages and submitting IO.  Once we get to a lower priority,
>>> sometimes the VM ends up freeing way too many pages.
>>>
>>> The fix is relatively simple: in shrink_zone() we can check how many
>>> pages we have already freed and break out of the loop.
>>>
>>> However, in order to do this we do need to know how many pages we already
>>> freed, so move nr_reclaimed into scan_control.
>> IIRC, Balbir-san explained the implemetation of the memcgroup 
>> force cache dropping feature need non bail out at the past reclaim 
>> throttring discussion.
>>

Yes, for we used that for force_empty() in the past, but see below

>> I am not sure about this still right or not (iirc, memcgroup implemetation
>> was largely changed).
>>
>> Balbir-san, Could you comment to this patch?
>>
>>
> I'm not Balbir-san but there is no "force-cache-dropping" feature now.
> (I have no plan to do that.)
> 
> But, mem+swap controller will need to modify reclaim path to do "cache drop
> first" becasue the amount of "mem+swap" will not change when "mem+swap" hit
> limit. It's now set "sc.may_swap" to 0.
> 

Yes, there have been several changes to force_empty() and its meaning, including
movement of accounts. Since you've made most of the recent changes, your
comments are very relevant.

> Hmm, I hope memcg is a silver bullet to this kind of special? workload in
> long term.

:-) From my perspective, hierarchy, soft limits (sharing memory when there is no
contention), some form of over commit support and getting swappiness to work
correctly are very important for memcg.

-- 
	Balbir
