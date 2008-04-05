Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYDETA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYDETA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYDETAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 15:00:17 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46235 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYDETAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:00:16 -0400
Message-ID: <47F7CC08.4090209@linux.vnet.ibm.com>
Date: Sun, 06 Apr 2008 00:29:20 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <6599ad830804040112q3dd5333aodf6a170c78e61dc8@mail.gmail.com> <47F5E69C.9@linux.vnet.ibm.com> <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com> <47F5F3FA.7060709@linux.vnet.ibm.com> <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com> <47F79102.6090406@linux.vnet.ibm.com> <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com> <47F7BB69.3000502@linux.vnet.ibm.com> <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com>
In-Reply-To: <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sat, Apr 5, 2008 at 10:48 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Paul Menage wrote:
>>  > On Sat, Apr 5, 2008 at 7:47 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  >>  Repeating my question earlier
>>  >>
>>  >>  Can we delay setting task->cgroups = &init_css_set for the group_leader, until
>>  >>  all threads have exited?
>>  >
>>  > Potentially, yes. It also might make more sense to move the
>>  > exit_cgroup() for all threads to a later point rather than special
>>  > case delayed group leaders.
>>  >
>>
>>  Yes, that makes sense. I think that patch should be independent of this one
>>  though? What do you think?
> 
> Yes, it would probably need to be a separate patch. The current
> positioning of cgroup_exit() is more or less inherited from cpusets.
> I'd need to figure out if a change like that would break anything.
> 

Yes, thats understandable

>>  >
>>  > Yes, I agree it could potentially happen. But it seems like a strange
>>  > thing to do if you're planning to be not have the same groupings for
>>  > cpu and va.
>>
>>  It's easier to set it up that way. Usually the end user gets the same SLA for
>>  memory, CPU and other resources, so it makes sense to bind the controllers together.
>>
> 
> True - but in that case why wouldn't they have the same SLA for
> virtual address space too?
> 

Yes, mostly. That's why I had made the virtual address space patches as a config
option on top of the memory controller :)

>>  >>  I measured the overhead of removing the delay_group_leader optimization and
>>  >>  found a 4% impact on throughput (with volanomark, that is one of the
>>  >>  multi-threaded benchmarks I know of).
>>  >
>>  > Interesting, I thought (although I've never actually looked at the
>>  > code) that volanomark was more of a scheduling benchmark than a
>>  > process start/exit benchmark. How frequently does it have processes
>>  > (not threads) exiting?
>>  >
>>
>>  I could not find any other interesting benchmark for benchmarking fork/exits. I
>>  know that volanomark is heavily threaded, so I used it. The threads quickly exit
>>  after processing the messages, I thought that would be a good test to see the
>>  overhead.
> 
> But surely the performance of thread exits wouldn't be affected by the
> delay_group_leader(p) change, since none of the exiting threads would
> be a group leader. That optimization only matters when the entire
> process exits.
> 

On the client side, each JVM instance exits after the test. I see the thread
group leader exit as well through getdelays (I see TGID exits).

> Does oprofile show any interesting differences?

Need to try oprofile.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
