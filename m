Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbZAZBGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbZAZBGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 20:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZAZBGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 20:06:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35206 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZAZBGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 20:06:22 -0500
Message-ID: <497D0C81.5040406@linux.vnet.ibm.com>
Date: Sun, 25 Jan 2009 17:06:09 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu>
In-Reply-To: <20090121185021.GA8852@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> We are pleased to announce version 6 of our performance counters subsystem 
> implementation. The shortlog, diffstat and the combo patch can be found 
> below. The combo patch against latest -git (2.6.29-rc2) can be also found 
> at:
> 
>    http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
> 
> It's also available in tip/master at:
> 
>    http://people.redhat.com/mingo/tip.git/README
> 
> There are many changes in the v6 release:
> 
>  - PowerPC performance counters support from Paul Mackerras, for POWER6
>    and for the PPC970 family.
> 
>  - ioctl API to disable/enable individual counters and groups without
>    closing their fd. This can be useful for libraries, ad-hoc 
>    instrumentation and PAPI support.
> 
>  - 'pinned' and 'exclusive' counter attributes - for those
>    applications that want to influence counter scheduling explicitly.
> 
>  - The 'perfstat' utility (ex 'timec') has been updated:
> 
>       http://people.redhat.com/mingo/perfcounters/perfstat.c
> 
>  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
>    
>       http://people.redhat.com/mingo/perfcounters/kerneltop.c
> 
>  - Merged to latest mainline
> 
>  - Various fixes and other updates
> 
> 	Ingo

Hi Ingo,

Looking over the latest capabilities of this proposal, I am wondering 
how it can accommodate performance monitor units which have extra 
registers which require user-defined data to be loaded into them.

For example, on the Power architecture, there is an Instruction Matching 
Register which allows the counting of particular instructions. 
Currently, this is unsupported in perfmon2/3, but we have plans to add 
it, and it's pretty straight-forward to imagine how this would be done 
in perfmon.

But I don't see an obvious way to do it with your proposal.  Do you have 
any ideas how Performance Counters for Linux could accommodate this sort 
of PMU functionality?

One thought would be to change the event code to an event descriptor 
structure, which has room for lots of bits, including arch-defined bits 
(in the case of Power, an IMR value, and others).  This might also be a 
way to accommodate unit masks (and enums) as well, which Andi Kleen 
pointed out as an issue in an earlier LKML posting.

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

