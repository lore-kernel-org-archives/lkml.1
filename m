Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbZDCS0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbZDCS0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZDCSZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:25:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42065 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZDCSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:25:51 -0400
Message-ID: <49D654AB.4030207@linux.vnet.ibm.com>
Date: Fri, 03 Apr 2009 11:25:47 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins>
In-Reply-To: <1238763023.798.27.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra wrote:
> On Thu, 2009-04-02 at 11:12 +0200, Peter Zijlstra wrote:
>> plain text document attachment (perf_counter_callchain_context.patch)
>> Put in counts to tell which ips belong to what context.
>>
>>   -----
>>    | |  hv
>>    | --
>> nr | |  kernel
>>    | --
>>    | |  user
>>   -----
> 
> Right, just realized that PERF_RECORD_IP needs something similar if one
> if not able to derive the context from the IP itself..
> 
Three individual bits would suffice, or you could use a two-bit code -
00 = user
01 = kernel
10 = hypervisor
11 = reserved (or perhaps unknown)

Unfortunately, because of alignment, it would need to take up another 64 
bit word, wouldn't it?  Too bad you cannot sneak the bits into the IP in 
a machine independent way.

And since you probably need a separate word, that effectively doubles 
the amount of space taken up by IP samples (if we add a "no event 
header" option).  Should we add another bit in the record_type field - 
PERF_RECORD_IP_LEVEL (or similar) so that user-space apps don't have to 
get this if they don't need it?

Regards,

- Corey


