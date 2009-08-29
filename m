Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZH2CGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZH2CGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 22:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZH2CGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 22:06:00 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:63832 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZH2CGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 22:06:00 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2009 22:06:00 EDT
Message-ID: <4A988BB4.1030005@vflare.org>
Date: Sat, 29 Aug 2009 07:30:20 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 4/4] compcache: documentation
References: <200908241008.02184.ngupta@vflare.org> <661de9470908251003y3db1fb3awb648f9340cd0beb4@mail.gmail.com> <4A94293A.2090103@vflare.org> <20090828195303.GA4889@balbir.in.ibm.com>
In-Reply-To: <20090828195303.GA4889@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2009 01:23 AM, Balbir Singh wrote:
> * Nitin Gupta<ngupta@vflare.org>  [2009-08-25 23:41:06]:
>
>> On 08/25/2009 10:33 PM, Balbir Singh wrote:
>>
>>
>>>> +It consists of three modules:
>>>> + - xvmalloc.ko: memory allocator
>>>
>>> I've seen your case for a custom allocator, but why can't we
>>>
>>> 1) Refactor slob and use it
>>
>> SLOB is fundamentally a different allocator. It looked at it in detail
>> but could not image how can I make it suitable for the project. SLOB
>> really does not fit it.
>>
>>> 2) Do we care about the optimizations in SLUB w.r.t. scalability in
>>> your module? If so.. will xvmalloc meet those requirements?
>>>
>>
>> Scalability is desired which xvmalloc lacks in its current state. My
>> plan is to have a wrapper around xvmalloc that creates per-cpu pools
>> and leave xvmalloc core simple. Along with this, detailed profiling
>> needs to be done to see where the bottlenecks are in the core itself.
>>
>
> I've not yet tested the patches, but adding another allocator does
> worry me a bit. Do you intend to allow other users to consume the
> allocator routines?
>

No. This allocator is not compiled as separate module, does not export any
symbol and is compiled with ramzswap. So, no one else can use it.

Thanks,
Nitin
