Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYGDDUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYGDDUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 23:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYGDDUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 23:20:47 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:33012 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752035AbYGDDUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 23:20:47 -0400
Message-ID: <486D970F.2000607@linux.vnet.ibm.com>
Date: Fri, 04 Jul 2008 08:50:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.26-rc8-mm1] memrlimit: fix mmap_sem deadlock
References: <Pine.LNX.4.64.0807032143110.10641@blonde.site> <20080703160117.b3781463.akpm@linux-foundation.org> <486D81B9.9030704@linux.vnet.ibm.com> <20080703190123.1d72e9d1.akpm@linux-foundation.org>
In-Reply-To: <20080703190123.1d72e9d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 04 Jul 2008 07:19:45 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>> There doesn't seem to have been much discussion regarding your recent
>>> objections to the memrlimit patches.  But it caused me to put a big
>>> black mark on them.  Perhaps sending it all again would be helpful.
>> Black marks are not good, but there have been some silly issues found with them.
>> I have been addressing/answering concerns raised so far. Would you like me to
>> fold all patches and fixes and send them out for review again?
>>
>>
> 
> I was referring to the below (which is where the conversation ended).
> 
> It questions the basis of the whole feature.
> 

In the email below, I referred to Hugh's comment on tracking total_vm as a more
achievable target and it gives a rough approximation of something worth
limiting. I agree with him on those points and mentioned my motivation for the
memrlimit patchset. We also look forward to enhancing memrlimit to control
mlock'ed pages (as it provides the generic infrastructure to control RLIMIT'ed
resources). Given Hugh's comment, I looked at it from the more positive side
rather the pessimistic angle. I've had discussions along these lines with Paul
Menage and Kamezawa. In the past we've discussed and there are cases where
memrlimit is not useful (large VM allocations with sparse usage), but there are
cases as mentioned below in the motivation for memrlimits as to why and where
they are useful.

If there are suggestions to help improve the feature or provide similar
functionality without the noise; I am all ears

> 
> On Wed, 25 Jun 2008 06:31:05 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Hugh Dickins wrote:
>>
>> ...
>>
>>> (In passing, I'll add that I'm not a great fan of these memrlimits:
>>> to me it's loony to be charging people for virtual address space,
>>> it's _virtual_, and process A can have as much as it likes without
>>> affecting process B in any way.  You're following the lead of RLIMIT_AS,
>>> but I've always thought RLIMIT_AS a lame attempt to move into the mmap
>>> decade, after RLIMIT_DATA and RLIMIT_STACK no longer made sense.
>>>
>>> Taking Alan Cox's Committed_AS as a limited resource charged per mm makes
>>> much more sense to me: but yes, it's not perfect, and it is a lot harder
>>> to get its accounting right, and to maintain that down the line.  Okay,
>>> you've gone for the easier option of tracking total_vm, getting that
>>> right is a more achievable target.  And I accept that I may be too
>>> pessimistic about it: total_vm may often enough give a rough
>>> approximation to something else worth limiting.)
>> You seem to have read my mind, my motivation for memrlimits is
>>
>> 1. Administrators to set a limit and be sure that a cgroup cannot consume more
>> swap + RSS than the assigned virtual memory limit
>> 2. It allows applications to fail gracefully or decide what parts to free up
>> to get more memory or change their allocation pattern (a scientific application
>> deciding what size of matrix to allocate for example).
>>


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
