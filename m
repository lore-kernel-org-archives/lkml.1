Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbYDULpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbYDULpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYDULpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:45:46 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34140 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYDULpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:45:46 -0400
Message-ID: <480C7D87.5060909@linux.vnet.ibm.com>
Date: Mon, 21 Apr 2008 17:11:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, menage@google.com, xemul@openvz.org,
       shiwh@cn.fujitsu.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
References: <20080420072053.6bcb7884.akpm@linux-foundation.org> <Pine.LNX.4.64.0804210004470.1630@blonde.site> <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com> <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com> <20080421064725.GA32214@balbir.in.ibm.com> <Pine.LNX.4.64.0804211158001.10521@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804211158001.10521@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 21 Apr 2008, Balbir Singh wrote:
>> * Balbir Singh <balbir@linux.vnet.ibm.com> [2008-04-21 12:14:28]:
>>> Andrew Morton wrote:
>>>>> On Mon, 21 Apr 2008 09:30:59 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>>>> On Mon, 21 Apr 2008 00:51:30 +0100 (BST)
>>>>> Hugh Dickins <hugh@veritas.com> wrote:
>>>>>>>  disable-the-memory-controller-by-default-v3.patch
>>>>>>>  disable-the-memory-controller-by-default-v3-fix.patch
>>>>>> If those are to go in, then the sooner the better, yes.
>>>>>>
>>>>>> But though I argued for cgroup_disable=memory (or some such),
>>>>>> I think myself that taking it even further now (requiring an
>>>>>> additional cgroup_enable=memory at boottime to get the memcg
>>>>>> stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
>>>>>> confusing overkill, just messing around.
>>>> Yes, it does sound a bit silly.  I'd say just enable it, and provide a
>>>> cgroup_disable.
> 
> And 2.6.25 does already have that cgroup_disable=memory bootoption to
> disable the config-enabled MEM_RES_CTLR and almost all of its overhead
> (just leaving the extra pointer in struct page).
> 
>> OK, fair enough. Andi Kleen spoke about the overhead and how distros would
>> be impacted if they enabled CONFIG_MEM_RES_CTLR and it was not disabled by
>> default. I think the enable/disable is good. I just need to turn on/off
>> mem_cgroup_subsys.disabled. The patch is as simple as
>>  
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> That's a simple patch on top of:
> disable-the-memory-controller-by-default-v3.patch
> disable-the-memory-controller-by-default-v3-fix.patch
> 

Yes, which are in 2.6.25-mm1. I don't mean to sneak these patches in, just
pointing out an approach to solving that problem. I am not against removing the
patches mentioned above either. Your point of the overheads and the boot option
and the memory control being enabled by default in 2.6.25 is valid (we already
have those in).

> But even simpler is just to drop those patches, yes?

Yes

> What's the point of adding cgroup_enable if nothing uses it?
> And especially not for going into -stable.
> 

Yes, true

> I've added Andi to the Cc's, I don't want to sneak away something
> he's expecting there.  If 2.6.25 had gone out with a convention that
> controller infrastructure gets compiled in, but has then to be enabled
> at boottime or runtime, okay; but switching back and forth between
> defaults of enabled and disabled between releases (and between
> controllers, as you seem to envisage) bothers me.
> 

I am not trying to sneak anything in. We have two different view points on
enabling/disabling by default. I just wanted to show that making the change to
enable/disable is easy -- the patch was not meant for inclusion. The patch is
easy, but the decision needs more discussion.

> The config helptext (along with some misinformation) does conclude
> 	  Only enable when you're ok with these trade offs and really
> 	  sure you need the memory resource controller.
> so I don't see why we now need to switch to disabled by default both
> in config and at bootime - too many hurdles to my mind.

We do have differing opinions on this one. I think one of Andi's points was that
if a distro were to pick up 2.6.25 and they enabled CONFIG_CGROUPS_MEM_RES_CTLR
they would have several complaints of the overhead from users. I am open to what
is the best solution for such a situation. More opinions and brain-storming will
help.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
