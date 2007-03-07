Return-Path: <linux-kernel-owner+w=401wt.eu-S1422964AbXCGTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422964AbXCGTTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992490AbXCGTTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:19:18 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48952 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422964AbXCGTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:19:17 -0500
Message-ID: <45EF0F29.60305@vmware.com>
Date: Wed, 07 Mar 2007 11:14:49 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Dan Hecht <dhecht@vmware.com>
Subject: Re: Xen & VMI?
References: <45ED82D9.6050204@codemonkey.ws>	<8FFF7E42E93CC646B632AB40643802A80229779B@scsmsx412.amr.corp.intel.com>	<20070306203712.GC21736@elte.hu>	<1173228246.4644.85.camel@localhost.localdomain> <20070307081510.GB15111@elte.hu>
In-Reply-To: <20070307081510.GB15111@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 19:19:15.0771 (UTC) FILETIME=[7F0220B0:01C760ED]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 12:15 AM, Ingo Molnar wrote:
> On the other hand, Linux's internal details, semantics, approaches are a 
> lot more ad-hoc and alot more affected by changes in the hardware 
> environment - that's why i'd not like to see some external ABI 
> constraint limit aspects of those internals.
> 
> For example, VMI_CALL_SetAlarm takes a 'cycles' argument. Cycles is a 
> quite bad unit for an API, it should be absolute time, nanosec or 
> picosec based instead. We could easily see CPUs that have /no concept of 
> cycles/, at all! Even today's CPUs have hardly any fix concept of 
> cycles, due to cpufreq. It's as if 15 years ago we had based sys_mmap() 
> around the concept of '16-bit segments'. We could certainly make it work 
> on current hardware but it would look pretty awkward today.
> 
>

Ingo,

In the VMI definition, "cycles" does not mean "cpu cycles".  It is used 
in the normal way to mean "an interval of time during which a sequence 
of a recurring succession of events or phenomena is completed" 
[Merriam-Webster].  In this case, the recurring event is the increment 
of a counter.  The routine VMI_CALL_GetCycleFrequency defines how many 
of these events occur per second.  The rate is not variable, so is not 
subject to cpu phenomena such as cpufreq.  And it does not need to be 
tied in any way to cpu cycle frequency.  How your cpu is implemented is 
not relevant.

If a hypervisor wishes to expose it's time counters in units of 
nanoseconds, then it simply returns 1000000000 from GetCycleFrequency.

Dan
