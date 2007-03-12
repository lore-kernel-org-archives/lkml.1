Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXCLQIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXCLQIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030489AbXCLQIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:08:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:48049 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030477AbXCLQIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:08:13 -0400
Message-ID: <45F57AEB.5030405@argo.co.il>
Date: Mon, 12 Mar 2007 18:08:11 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: discuss@x86-64.org, Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 TRY#3] optimize and simplify get_cycles_sync()
References: <20070309150825.GA13481@amd.com> <20070309151511.GE13481@amd.com> <45F1A2FB.7040206@argo.co.il> <20070312130245.GE8922@amd.com>
In-Reply-To: <20070312130245.GE8922@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Fri, Mar 09, 2007 at 08:10:03PM +0200, Avi Kivity wrote:
>   
>> Joerg Roedel wrote:
>>     
>>> From: Joerg Roedel <joerg.roedel@amd.com>
>>>
>>> This patch simplifies the get_cycles_sync() function by removing
>>> the #ifdefs from it. Further it introduces an optimization for AMD
>>> processors. There the RDTSCP instruction is used instead of CPUID;RDTSC
>>> which is helpfull if the kernel runs as a KVM guest. Running as a guest
>>> makes CPUID very expensive because it causes an intercept of the guest.
>>>
>>>  +#define RDTSCP ".byte 0x0f, 0x01, 0xf9"
>>> +	alternative_io_two("cpuid\nrdtsc",
>>> +			   "rdtsc", X86_FEATURE_SYNC_RDTSC,
>>> +			   ".byte 0x0f, 0x01, 0xf9", X86_FEATURE_RDTSCP,
>>>  
>>>       
>> why not use the RDTSCP macro here?
>>     
>
> Does this macro exist? I couldn't found it in the current git tree. And
> the rdtscp macros in msr.h use the plain opcode too.
>   

-ENOCOFFEE?  You defined the macro 3 lines above the .byte directive...


-- 
error compiling committee.c: too many arguments to function

