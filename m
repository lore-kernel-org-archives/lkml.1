Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZEKWiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZEKWiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbZEKWh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:37:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49695 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbZEKWh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:37:56 -0400
Message-ID: <4A08A8C6.1090302@linux.vnet.ibm.com>
Date: Mon, 11 May 2009 15:37:58 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
References: <20090508165219.469818319@chello.nl> <20090508170028.837558214@chello.nl> <18951.32643.749495.538351@drongo.ozlabs.ibm.com> <4A086A89.6030905@linux.vnet.ibm.com> <18952.36878.942836.803265@cargo.ozlabs.ibm.com>
In-Reply-To: <18952.36878.942836.803265@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Mackerras wrote:
> Corey Ashford writes:
> 
>> One problem that I was seeing was that disabling only the group leader didn't 
>> keep the group member hardware counters from continuing to run and generate 
>> overflows, and causing sample records to be put in the mmap buffer.
> 
> That's very strange.  Disabling the group leader should have taken the
> whole group off the PMU and so none of the members should have been
> able to generate any more overflows or sample records.  What machines
> did you see this on?
> 
>> Was this the intention?
> 
> Not at all.
> 
>> For PAPI, we really need to be able to disable, at least, the sample records 
>> from going into the mmap buffers.  Even better would be to stop the hardware 
>> counters from counting while disabled.
> 
> Disabling the leader should be doing all that.

I was seeing that on Power5.  On 5/6/2009, I sent along a test case that was 
supposed to duplicate the sequence of operations, without using PAPI, to Peter 
Zijlstra, cc'ing you.  However, I was unable to get any signals delivered to 
user space with that code, so I was unable to reproduce the problem outside of 
the PAPI test case.  I don't know why signal delivery doesn't work with that 
test case... I spent quite a lot of time verifying that it was doing the right 
thing, but could never get it to work.

I hate to ask you to debug that test case's signal handling, but that might be 
the fastest way to reproduce the behavior I was seeing inside of PAPI.  If not, 
I can try to get back to the test case later this week and have another go at 
it, perhaps instrumenting the kernel to try to determine why its not sending 
signals.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

