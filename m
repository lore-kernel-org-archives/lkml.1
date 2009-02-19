Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZBSVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZBSVxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbZBSVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:53:10 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56784 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbZBSVxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:53:09 -0500
Message-ID: <499DD4BE.2000704@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 13:53:02 -0800
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
[snip]

Hi Ingo,

As I was starting to put together a simple implementation of PAPI on top 
of PCL for Power, I noticed that PCL does not seem to have any sort of 
versioning and way of ascertaining the current capabilities of what is 
in the kernel.

This information is needed by tools and libraries built on top of PCL so 
that they can know what is supported and if any bugs need to be worked 
around.

Have you thought about how to present this information to the user?  I 
was thinking that since you already have 
/sys/devices/system/cpu/perf_counter set up, maybe we could add some 
more files in there.  Perhaps a "version" file (perfmon does this), and 
maybe a "capabilities" file which contains a set of strings exhibiting 
the supported features.  For example,

arch-independent:
MMAPPED_SAMPLE_BUFFER
MMAPPED_SAMPLE_BUFFER_MAX_SIZE=0x20000
CUSTOM_SAMPLING

on powerpc arch:
POWER6_IMC
POWER6_THRESHOLD

or on x86:
NEHALEM_PEBS

etc.

Or it could be a bit mask whose bits are defined in an include file.

Personally, I like the strings approach because it's more extensible, 
and would not require modifying /usr/include files when you pick up a 
new kernel.  Perhaps the arch-independent and arch-dependent 
capabilities would be in two different files to make the implementation 
easier.


-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

