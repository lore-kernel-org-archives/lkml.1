Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZFRTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZFRTl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZFRTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:41:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZFRTlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:41:19 -0400
Message-ID: <4A3A9844.8030004@redhat.com>
Date: Thu, 18 Jun 2009 15:40:52 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Larry Woodman <lwoodman@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?RnLpppjpp7tpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rostedt@goodmis.org
Subject: Re: [Patch] mm tracepoints update - use case.
References: <20090423092933.F6E9.A69D9226@jp.fujitsu.com>	 <4A36925D.4090000@redhat.com> <20090616170811.99A6.A69D9226@jp.fujitsu.com> <1245352954.3212.67.camel@dhcp-100-19-198.bos.redhat.com>
In-Reply-To: <1245352954.3212.67.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Woodman wrote:

>> - Please don't display mm and/or another kernel raw pointer.
>>   if we assume non stop system, we can't use kernel-dump. Thus kernel pointer
>>   logging is not so useful.
> 
> OK, I just dont know how valuable the trace output is with out some raw
> data like the mm_struct.

I believe that we do want something like the mm_struct in
the trace info, so we can figure out which process was
allocating pages, etc...

>> - Please consider how do this feature works on mem-cgroup.
>>   (IOW, please don't ignore many "if (scanning_global_lru())")

Good point, we want to trace cgroup vs non-cgroup reclaims,
too.

>> - tracepoint caller shouldn't have any assumption of displaying representation.
>>   e.g.
>>     wrong)  trace_mm_pagereclaim_pgout(mapping, page->index<<PAGE_SHIFT, PageAnon(page));
>>     good)   trace_mm_pagereclaim_pgout(mapping, page)
> 
> OK.
> 
>>   that's general and good callback and/or hook manner.

How do we figure those out from the page pointer at the time
the tracepoint triggers?

I believe that it would be useful to export that info in the
trace point, since we cannot expect the userspace trace tool
to figure out these things from the struct page address.

Or did I overlook something here?

-- 
All rights reversed.
