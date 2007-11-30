Return-Path: <linux-kernel-owner+w=401wt.eu-S934718AbXK3DON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbXK3DON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbXK3DNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:13:53 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42930 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501AbXK3DNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:13:51 -0500
Message-ID: <474F7FDF.3000506@linux.vnet.ibm.com>
Date: Fri, 30 Nov 2007 08:43:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linux Memory Management List <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@sw.ru>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: What can we do to get ready for memory controller merge in 2.6.25
References: <474ED005.7060300@linux.vnet.ibm.com> <200711301311.48291.nickpiggin@yahoo.com.au>
In-Reply-To: <200711301311.48291.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 30 November 2007 01:43, Balbir Singh wrote:
>> They say better strike when the iron is hot.
>>
>> Since we have so many people discussing the memory controller, I would
>> like to access the readiness of the memory controller for mainline
>> merge. Given that we have some time until the merge window, I'd like to
>> set aside some time (from my other work items) to work on the memory
>> controller, fix review comments and defects.
>>
>> In the past, we've received several useful comments from Rik Van Riel,
>> Lee Schermerhorn, Peter Zijlstra, Hugh Dickins, Nick Piggin, Paul Menage
>> and code contributions and bug fixes from Hugh Dickins, Pavel Emelianov,
>> Lee Schermerhorn, YAMAMOTO-San, Andrew Morton and KAMEZAWA-San. I
>> apologize if I missed out any other names or contributions
>>
>> At the VM-Summit we decided to try the current double LRU approach for
>> memory control. At this juncture in the space-time continuum, I seek
>> your support, feedback, comments and help to move the memory controller
> 
> Do you have any test cases, performance numbers, etc.? And also some
> results or even anecdotes of where this is going to be used would be
> interesting...
> 

Some test results were posted at

http://lkml.org/lkml/2007/8/17/69
http://lkml.org/lkml/2007/8/19/36
http://lwn.net/Articles/242554/

Some results for the RSS controller can be found in the OLS paper

https://ols2006.108.redhat.com/2007/Reprints/singh-Reprint.pdf

and at

http://lkml.org/lkml/2007/5/18/1

As far as test cases are concerned, I have a simple test case that I use
that allocates memory and touches all the allocated memory in a loop. I
can post that out if required. It uses various types of allocation

1. mmaped memory
2. anonymous memory
3. shared memory

I also run various benchmarks inside a control group, limited to 400 MB
of RAM.

One interesting that I noticed was that when I booted with mem=<some
memory> and created a container with the same <some value>. The swapout
test case ran much faster in the container (NOTE: This was prior to the
swap cache changes).

KAMEZAWA-San posted some test results on background reclaim and per zone
reclaim

http://forum.openvz.org/index.php?t=tree&th=4696&mid=23964&&rev=&reveal=

The simplest use cases that come to mind are

1. Memory control for containers/virtualization
2. Job Isolation


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
