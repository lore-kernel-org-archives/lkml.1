Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZCaRMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZCaRMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZCaRMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:12:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44791 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbZCaRMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:12:01 -0400
Message-ID: <49D24ED0.9060008@linux.vnet.ibm.com>
Date: Tue, 31 Mar 2009 10:11:44 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
References: <20090330170701.856843742@chello.nl> <20090330171024.254266860@chello.nl> <18897.46177.528910.51044@cargo.ozlabs.ibm.com> <1238481552.28248.1384.camel@twins> <49D1C544.7020403@linux.vnet.ibm.com> <18897.56973.324304.995540@cargo.ozlabs.ibm.com> <1238508032.8530.278.camel@twins>
In-Reply-To: <1238508032.8530.278.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-03-31 at 20:12 +1100, Paul Mackerras wrote:
>> Corey Ashford writes:
>>
>>> If this is the case, what is the exact meaning of PERF_COUNTER_SIMPLE 
>>> now? and PERF_COUNTER_GROUP?  One simplification would be that reading 
>>> the fd of a group leader would always read up all of the counters in the 
>>> group (along with their enabled and running times if those bits are 
>>> set), and that reading a single counter's fd would yield only that 
>>> counter's values and times (if enabled).  In effect, these two values, 
>>> PERF_COUNTER_GROUP and PERF_COUNTER_SIMPLE would no longer be necessary 
>>> at all.  Other bits would be used to determine what's in the mmap'd samples.
>> Now that events are only read through mmap, it's quite simple -
>> hw_event.read_format controls what read() gives you, and
>> hw_event.record_type controls what gets put into the pages that you
>> get with mmap.
>>
>> Currently read_format and record_type don't use the same set of bit
>> definitions.  Maybe they should?  I don't have a strong feeling about
>> it, but that might be a nice simplification.
> 
> Something like the below? 
> 
> That still has the record and read things separate, but as one unified
> overflow output.
> 
> I reduced record and read fields to 32bits, as the output type only has
> 32bits.
> 
> diff did a wonderful job making the patch unreadable :/
>

This looks great!  I like the idea of two bit vectors to describe what 
you get when you read and the format of the mmap'd data.  And I like the 
ability not to include the header on each record if the user space 
program knows the exact format of the sample records.

Paul is right, too, that having a read_format bit to determine whether 
reading the leader gives all of the counters or just the leader is a 
nice addition.  I can't think of when I'd use it, but it's a good 
capability.

- Corey

