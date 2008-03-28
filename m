Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbYC1SRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbYC1SRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYC1SRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:17:23 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46206 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYC1SRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:17:22 -0400
Message-ID: <47ED354C.2040502@linux.vnet.ibm.com>
Date: Fri, 28 Mar 2008 23:43:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups (v2)
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain> <6599ad830803261522p45a9daddi8100a0635c21cf7d@mail.gmail.com> <47EB5528.8070800@linux.vnet.ibm.com> <6599ad830803270728y354b567s7bfe8cb7472aa065@mail.gmail.com> <47EBDE7B.4090002@linux.vnet.ibm.com> <6599ad830803271144k635da1d8y106710152bb9c3be@mail.gmail.com> <47EC6D29.1080201@linux.vnet.ibm.com> <6599ad830803280737lf6882bapd9707c02bf26ef12@mail.gmail.com>
In-Reply-To: <6599ad830803280737lf6882bapd9707c02bf26ef12@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Mar 27, 2008 at 8:59 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  > Java (or at least, Sun's JRE) is an example of a common application
>>  > that does this. It creates a huge heap mapping at startup, and faults
>>  > it in as necessary.
>>  >
>>
>>  Isn't this controlled by the java -Xm options?
>>
> 
> Probably - that was just an example, and the behaviour of Java isn't
> exactly unreasonable. A different example would be an app that maps a
> massive database file, but only pages small amounts of it in at any
> one time.
> 
>>  I understand, but
>>
>>  1. The system by default enforces overcommit on most distros, so why should we
>>  not have something similar and that flexible for cgroups.
> 
> Right, I guess I should make it clear that I'm *not* arguing that we
> shouldn't have a virtual address space limit subsystem.
> 
> My main arguments in this and my previous email were to back up my
> assertion that there are a significant set of real-world cases where
> it doesn't help, and hence it should be a separate subsystem that can
> be turned on or off as desired.
> 
> It strikes me that when split into its own subsystem, this is going to
> be very simple - basically just a resource counter and some file
> handlers. We should probably have something like
> include/linux/rescounter_subsys_template.h, so you can do:
> 
> #define SUBSYS_NAME va
> #define SUBSYS_UNIT_SUFFIX in_bytes
> #include <linux/rescounter_subsys_template.h>
> 
> then all you have to add are the hooks to call the rescounter
> charge/uncharge functions and you're done. It would be nice to have a
> separate trivial subsystem like this for each of the rlimit types, not
> just virtual address space.
> 

OK, I'll consider doing a separate controller, once we get the mm->owner issue
sorted out.

>>   And specifying
>>  > them manually requires either unusually clueful users (most of whom
>>  > have enough trouble figuring out how much physical memory they'll
>>  > need, and would just set very high virtual address space limits) or
>>  > sysadmins with way too much time on their hands ...
>>  >
>>
>>  It's a one time thing to setup for sysadmins
>>
> 
> Sure, it's a one-time thing to setup *if* your cluster workload is
> completely static.
> 
>>  > As I said, I think focussing on ways to tell apps that they're running
>>  > low on physical memory would be much more productive.
>>  >
>>
>>  We intend to do that as well. We intend to have user space OOM notification.
> 
> We've been playing with a user-space OOM notification system at Google
> - it's on my TODO list to push it to mainline (as an independent
> subsystem, since either cpusets or the memory controller can be used
> to cause OOMs that are localized to a cgroup). What we have works
> pretty well but I think our interface is a bit too much of a kludge at
> this point.

It's good to know you have something generic working. I was planning to start
work on it later.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
