Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXEaO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXEaO1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXEaO1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:27:30 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:21280 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXEaO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:27:29 -0400
Date: Thu, 31 May 2007 08:27:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Case: 7454422: Re: Kernel 2.6.21.3 does not work with 8GB of RAM
 on Intel 965WH motherboards. (FULL DMESG)
In-reply-to: <Pine.LNX.4.64.0705310906590.6709@p34.internal.lan>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       crmotherboard@intel.com
Message-id: <465EDB4F.6020800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <82e4877d0705301757v580a4ca5yebe2a565f0b97552@mail.gmail.com>
 <465E513E.60903@shaw.ca> <465EC464.7050302@gmail.com>
 <Pine.LNX.4.64.0705310906590.6709@p34.internal.lan>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> On Thu, 31 May 2007, Parag Warudkar wrote:
> 
>> Robert Hancock wrote:
>>> I think that mem=8832M would work as well, to make the kernel use 
>>> only the memory that is marked cacheable. (It looks like this 
>>> parameter takes the highest memory address we want the kernel to use, 
>>> not the highest memory amount.)
>>>
>> Yep, and that would be much easier too.
>>
>> I am curious though as this seems to be somewhat common a problem, 
>> could we make the kernel analyze which memory is not cacheable (it 
>> already knows this via MTRR) and not use that portion for anything? 
>> Plus may be warn the user to contact their BIOS vendor to correct the 
>> problem?
>>
>> I think that would be possible - even if the kernel knows late that 
>> the memory was uncached we could migrate those pages in that region to 
>> someplace else?
>>
>> Parag
>>
> 
> That is an excellent question and I wonder the same thing.  I also had 
> this problem when I only used 4GB of ram and upgraded the (another 
> motherboard, I have two) past version 1666P and I had no idea what was 
> going on other than the BIOS did not work correctly.
> 
> In this case however it worked with 4GB with bios version 1612P but not 
> with 8GB.  Is this the case of a buggy BIOS for the 965 chipset or do 
> Intel boards have a lot of issues?

We could conceivably generate a warning if the MTRRs don't map all of 
the physical memory as write-back. Actually, conceivably we could 
actually go and fix up the MTRRs if we found them to be wrong according 
to the E820 memory map. That would be more complicated, however.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

