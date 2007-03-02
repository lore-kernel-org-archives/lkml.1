Return-Path: <linux-kernel-owner+w=401wt.eu-S1422844AbXCBES6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844AbXCBES6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422845AbXCBES6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:18:58 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33830 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422844AbXCBES5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:18:57 -0500
Message-ID: <45E7A59E.6020004@in.ibm.com>
Date: Fri, 02 Mar 2007 09:48:38 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011642190.12485@woody.linux-foundation.org> <45E7835A.8000908@in.ibm.com> <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703011939120.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 2 Mar 2007, Balbir Singh wrote:
>>> My personal opinion is that while I'm not a huge fan of virtualization,
>>> these kinds of things really _can_ be handled more cleanly at that layer,
>>> and not in the kernel at all. Afaik, it's what IBM already does, and has
>>> been doing for a while. There's no shame in looking at what already works,
>>> especially if it's simpler.
>> Could you please clarify as to what "that layer" means - is it the
>> firmware/hardware for virtualization? or does it refer to user space?
> 
> Virtualization in general. We don't know what it is - in IBM machines it's 
> a hypervisor. With Xen and VMware, it's usually a hypervisor too. With 
> KVM, it's obviously a host Linux kernel/user-process combination.
> 

Thanks for clarifying.

> The point being that in the guests, hotunplug is almost useless (for 
> bigger ranges), and we're much better off just telling the virtualization 
> hosts on a per-page level whether we care about a page or not, than to 
> worry about fragmentation.
> 
> And in hosts, we usually don't care EITHER, since it's usually done in a 
> hypervisor.
> 
>> It would also be useful to have a resource controller like per-container
>> RSS control (container refers to a task grouping) within the kernel or
>> non-virtualized environments as well.
> 
> .. but this has again no impact on anti-fragmentation.
> 

Yes, I agree that anti-fragmentation and resource management are independent
of each other. I must admit to being a bit selfish here, in that my main
interest is in resource management and we would love to see a well
written  and easy to understand resource management infrastructure and 
controllers to control CPU and memory usage. Since the issue of
per-container RSS control came up, I wanted to ensure that we do not mix
up resource control and anti-fragmentation.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
