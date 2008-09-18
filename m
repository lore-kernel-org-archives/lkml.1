Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIRD7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIRD7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 23:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYIRD7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 23:59:10 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:51580 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYIRD7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 23:59:09 -0400
Message-ID: <48D1D1C2.9060204@linux.vnet.ibm.com>
Date: Wed, 17 Sep 2008 20:57:54 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page (v3)
References: <200809091500.10619.nickpiggin@yahoo.com.au> <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com> <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com> <20080910012048.GA32752@balbir.in.ibm.com> <1221085260.6781.69.camel@nimitz> <48C84C0A.30902@linux.vnet.ibm.com> <1221087408.6781.73.camel@nimitz> <20080911103500.d22d0ea1.kamezawa.hiroyu@jp.fujitsu.com> <48C878AD.4040404@linux.vnet.ibm.com> <20080911105638.1581db90.kamezawa.hiroyu@jp.fujitsu.com> <20080917232826.GA19256@balbir.in.ibm.com> <20080917184008.92b7fc4c.akpm@linux-foundation.org>
In-Reply-To: <20080917184008.92b7fc4c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 17 Sep 2008 16:28:26 -0700 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Before trying the sparsemem approach, I tried a radix tree per node,
>> per zone and I seemed to actually get some performance
>> improvement.(1.5% (noise maybe))
>>
>> But please do see and review (tested on my x86_64 box with unixbench
>> and some other simple tests)
>>
>> v4..v3
>> 1. Use a radix tree per node, per zone
>>
>> v3...v2
>> 1. Convert flags to unsigned long
>> 2. Move page_cgroup->lock to a bit spin lock in flags
>>
>> v2...v1
>>
>> 1. Fix a small bug, don't call radix_tree_preload_end(), if preload fails
>>
>> This is a rewrite of a patch I had written long back to remove struct page
>> (I shared the patches with Kamezawa, but never posted them anywhere else).
>> I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug 2008).
>>
>> I've tested the patches on an x86_64 box, I've run a simple test running
>> under the memory control group and the same test running concurrently under
>> two different groups (and creating pressure within their groups).
>>
>> Advantages of the patch
>>
>> 1. It removes the extra pointer in struct page
>>
>> Disadvantages
>>
>> 1. Radix tree lookup is not an O(1) operation, once the page is known
>>    getting to the page_cgroup (pc) is a little more expensive now.
> 
> Why are we doing this?  I can guess, but I'd rather not have to.
> 
> a) It's slower.
> 
> b) It uses even more memory worst-case.
> 
> c) It uses less memory best-case.
> 
> someone somewhere decided that (Aa + Bb) / Cc < 1.0.  What are the values
> of A, B and C and where did they come from? ;)
> 
> (IOW, your changelog is in the category "sucky", along with 90% of the others)

Yes, I agree, to be honest we discussed the reasons on the mailing list and
those should go to the changelog. I'll do that in the next version of the
patches. These are early RFC patches, but the changelog does suck.

-- 
	Balbir
