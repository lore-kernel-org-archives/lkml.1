Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbXLTQY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbXLTQY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXLTQYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:24:43 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44504 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbXLTQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:24:42 -0500
Message-ID: <476A972F.6050904@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2007 21:54:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Hugh Dickins <hugh@veritas.com>, Dave Hansen <haveblue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop> <1198084473.15321.48.camel@localhost> <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com> <1198158702.6821.8.camel@twins> <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com> <1198160410.6821.13.camel@twins>
In-Reply-To: <1198160410.6821.13.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2007-12-20 at 14:16 +0000, Hugh Dickins wrote:
>> On Thu, 20 Dec 2007, Peter Zijlstra wrote:
>>> On Thu, 2007-12-20 at 13:14 +0000, Hugh Dickins wrote:
>>>> On Wed, 19 Dec 2007, Dave Hansen wrote:
>>>>>> -       page_assign_page_cgroup(page, NULL);
>>>>>> +       VM_BUG_ON(page_get_page_cgroup(page));
>>>>> Hi Balbir,
>>>>>
>>>>> You generally want to do these like:
>>>>>
>>>>> 	foo = page_assign_page_cgroup(page, NULL);
>>>>> 	VM_BUG_ON(foo);
>>>>>
>>>>> Some embedded people have been known to optimize kernel size like this:
>>>>>
>>>>> 	#define VM_BUG_ON(x) do{}while(0)
>>>> Balbir's patch looks fine to me: I don't get your point there, Dave.
>>> There was a lengthy discussion here:
>>>   http://lkml.org/lkml/2007/12/14/131
>>>
>>> on the merit of debug statements with side effects.
>> Of course, but what's the relevance?
>>
>>> But looking at our definition:
>>>
>>> #ifdef CONFIG_DEBUG_VM
>>> #define VM_BUG_ON(cond) BUG_ON(cond)
>>> #else
>>> #define VM_BUG_ON(condition) do { } while(0)
>>> #endif
>>>
>>> disabling CONFIG_DEBUG_VM breaks the code as proposed by Balbir in that
>>> it will no longer acquire the reference.
>> But what reference?
>>
>> struct page_cgroup *page_get_page_cgroup(struct page *page)
>> {
>> 	return (struct page_cgroup *)
>> 		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
>> }
>>
>> I guess the issue is that often a "get" function has a complementary
>> "put" function, but this isn't one of them.  Would page_page_cgroup
>> be a better name, perhaps?  I don't know.
> 
> Ah, yes, I mistakenly assumed it was a reference get. In that case I
> stand corrected and do not have any objections.
> 

I was going to say the same thing, page_get_page_cgroup() does not hold
any references. May be _get_ in the name is confusing.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
