Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbYEFJkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbYEFJkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762220AbYEFJk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:40:28 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:64630 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761199AbYEFJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:40:26 -0400
Message-ID: <482027BB.3090705@monstr.eu>
Date: Tue, 06 May 2008 11:41:15 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: John Williams <john.williams@petalogix.com>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       John Linn <linnj@xilinx.com>, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca
Subject: Re: [PATCH 07/56] microblaze_v2: Signal support
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <20080505213244.8DC757A0084@mail70-wa4.bigfish.com> <1210030436.5798.148.camel@localhost> <20080506001339.619971A58057@mail55-wa4.bigfish.com> <1210033550.5798.185.camel@localhost> <20080506003341.AFA5911E804F@mail138-va3.bigfish.com>
In-Reply-To: <20080506003341.AFA5911E804F@mail138-va3.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope that conclusion is remove #if 0 from signal.c code.

M


> You're right.  (I think I've been staring at this too much today... :)
> 
> Steve
> 
>> -----Original Message-----
>> From: John Williams [mailto:john.williams@petalogix.com]
>> Sent: Monday, May 05, 2008 5:26 PM
>> To: Stephen Neuendorffer
>> Cc: monstr@seznam.cz; linux-kernel@vger.kernel.org; arnd@arndb.de;
> linux-arch@vger.kernel.org; John
>> Linn; matthew@wil.cx; will.newton@gmail.com; drepper@redhat.com;
> microblaze-uclinux@itee.uq.edu.au;
>> grant.likely@secretlab.ca; Michal Simek
>> Subject: RE: [PATCH 07/56] microblaze_v2: Signal support
>>
>> On Mon, 2008-05-05 at 17:13 -0700, Stephen Neuendorffer wrote:
>>> I'm somewhat ignorant about what this code is attempting to do, but
> with
>>> some quick poking around (m68knommu, blackfin) seems to suggest that
>>> other architectures don't do this, while others (v850) have almost
>>> exactly the same code (although they are somewhat smarter and are
>>> careful not to flush the whole cache).
>>>
>>> At the very least, it seems like there is some work in this area
> needed.
>> flush_cache_sigtramp should just invalidate 8 bytes up from the base
>> address of the trampoline.  This is just the region on the process
> stack
>> where we insert a kind of call-back back.  Writing the opcodes goes
> via
>> the dcache, and so there's a vanishingly small possibility that the
> CPU
>> will get a false hit on on an icache fetch when the code is executed.
>>
>> That was what Michal's patch had when I scanned it yesterday.  It
>> certainly won't/shouldn't be invalidating the entire cache.
>>
>> Cheers,
>>
>> John
>>
>>
> 
> 
> 
> 

