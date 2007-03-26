Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXCZCgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXCZCgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 22:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXCZCgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 22:36:11 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:54616 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbXCZCgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 22:36:10 -0400
Message-ID: <46073197.2020707@in.ibm.com>
Date: Mon, 26 Mar 2007 08:06:07 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dave Hansen <hansendc@us.ibm.com>
Subject: Re: Linux-VServer example results for sharing vs. separate mappings
 ...
References: <20070323193000.GB17007@MAIL.13thfloor.at> <20070323214235.94a3e899.akpm@linux-foundation.org> <20070324183806.GA7312@MAIL.13thfloor.at> <20070324121906.aff91c93.akpm@linux-foundation.org> <460645EB.3030201@in.ibm.com> <20070325105109.b15c74ac.akpm@linux-foundation.org>
In-Reply-To: <20070325105109.b15c74ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Don't we break the global LRU with this scheme?
> 
> Sure, but that's deliberate!
> 
> (And we don't have a global LRU - the LRUs are per-zone).
> 

Yes, true. But if we use zones for containers and say we have 400
of them, with all of them under limit. When the system wants
to reclaim memory, we might not end up reclaiming the best pages.
Am I missing something?

>>> b) Create a new memory abstraction, call it the "software zone", which
>>>    is mostly decoupled from the present "hardware zones".  Most of the MM
>>>    is reworked to use "software zones".  The "software zones" are
>>>    runtime-resizeable, and obtain their pages via some means from the
>>>    hardware zones.  A container uses a software zone.
>>>
>> I think the problem would be figuring out where to allocate memory from?
>> What happens if a software zone spans across many hardware zones?
> 
> Yes, that would be the tricky part.  But we generally don't care what
> physical zone user pages come from, apart from NUMA optimisation.
> 
>> The reclaim mechanism proposed *does not impact the non-container users*.
> 
> Yup.  Let's keep plugging away with Pavel's approach, see where it gets us.
> 

Yes, we have some changes that we've made to the reclaim logic, we hope
to integrate a page cache controller soon. We are also testing the
patches. Hopefully soon enough, they'll be in a good state and we can
request you to merge the containers and the rss limit (plus page cache)
controller soon.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
