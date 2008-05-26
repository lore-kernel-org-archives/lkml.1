Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbYEZSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbYEZSiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYEZSiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:38:06 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57469 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbYEZSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:38:03 -0400
Message-ID: <483B0348.2000204@linux.vnet.ibm.com>
Date: Tue, 27 May 2008 00:06:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org>
In-Reply-To: <20080526110040.5ddc4656@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 26 May 2008 22:54:43 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Arjan,
>>
>>
>> These problems exist anyway, irrespective of scaled accounting (I'd
>> say that they are exceptions)
>>
>> 1. The management tool does have access to the current frequency and
>> maximum frequency, irrespective of scaled accounting. The decision
>> could still be taken on the data that is already available and
>> management tools can already use them 
> 
> it's sadly not as easy as you make it sound. From everything you wrote
> you're making the assumption "if we're not at maximum frequency, we
> have room to spare", which is very much not a correct assumption
> 

That's true in general. If the CPUs are throttled due to overheating, the system
management application will figure out that it cannot change the frequency. How
do I interpret my CPU frequency applet's data when it says that the system is
running at 46%?

>> 2. With IDA, we'd have to
>> document that APERF/MPERF can be greater than 100% if the system is
>> overclocked.
>>
>> Scaled accounting only intends to provide data already available.
>> Interpretation is left to management tools and we'll document the
>> corner cases that you just mentioned.
> 
> IDA is not overclocking, nor is it a corner case *at all*. It's the
> common case in fact on more modern systems. Having the kernel present
> "raw" data to applications that then have no idea how to really use it
> to be honest isn't very attractive to me as idea: you're presenting a
> very raw hardware interface that will keep changing over time in terms
> of how to interpret the data... the kernel needs to abstract such hard
> stuff from applications, not fully expose them to it. Especially since
> these things *ARE* tricky and *WILL* change. Future x86 hardware will
> have behavior that makes the "oh we'll document the corner cases"
> extremely unpractical. Heck, even todays hardware (but arguably not yet
> the server hardware) behaves like that. "Documenting the common case as
> corner case" is not the right thing to do when introducing some new
> behavior/interface. Sorry.

Before I argue against that, I would like to ask

1. How are APERF/MPERF be meant to be utilized?
2. The CPU frequency driver/governer uses APERF/MPERF as well - we could argue
and say that it should not be using/exposing that data to user space or using
that data to make decisions.
3. How do I answer the following problem

My CPU utilization is 50% at all frequencies (since utilization is time based),
does it mean that frequency scaling does not impact my workload?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
