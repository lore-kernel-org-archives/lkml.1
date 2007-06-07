Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXFGNeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXFGNeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbXFGNdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:33:55 -0400
Received: from spatial.ca ([66.11.172.77]:16980 "EHLO fawkes.spatial.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbXFGNdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:33:54 -0400
Message-ID: <46680940.3070707@spatial.ca>
Date: Thu, 07 Jun 2007 09:33:52 -0400
From: Tom Moore <tmoore@spatial.ca>
Reply-To: tmoore@spatial.ca
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
References: <46642C60.209@spatial.ca>	 <20070604191052.GD10008@csclub.uwaterloo.ca>	 <46646B4C.2070707@spatial.ca>	 <20070605185721.GW10006@csclub.uwaterloo.ca> <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
In-Reply-To: <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Sanitizer: Advosys mail filter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Satyam Sharma wrote:
> On 6/6/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
>> [...]
>> A better description would be:
>>
>> "Select this if you have a 32-bit processor and memory mapped in the 1GB
>> to 4GB address range."
>> [...]
>> That one would be better as:
>>
>> "Select this if you have a 32-bit processor and ram mapped in the 
>> address
>> range above 4GB."
>
> Ugh, no! How can we expect the user compiling a kernel to be *so*
> familiar with address space re-mapping / BIOSen (_his_ particular
> BIOS, specifically, and what / how it re-maps memory) / etc to be
> able to answer such questions? "Select ... if you have ... RAM
> installed" is perfectly clear, simple, and all that's needed.
>
However the KConfig help message as it is currently written is wrong.
> BTW, just imagine what a user would need to do to make things
> work as per your proposal. Build some kernel (don't care about
> memory loss), boot and find what his firmware prefers to do with
> address space (or else read up the BIOS documentation!) and
> _then_ again build a new kernel, this time selecting the options
> appropriately ...
I tried to do this, but the Kconfig help message was misleading.  I 
still needed to come here for help.
>
> Also, note that the change you're proposing is unnecessary! As
> Andi pointed out, this issue has more to do with broken BIOSen
> and the proper fix for Tom is to contact his vendor and flash /
> upgrade the BIOS firmware. I don't see anything wrong with the
> Kconfig help texts.
Andi was wrong.  It appears that he read the first sentence of my email 
and jumped to a conclusion.  The /proc/mtrr output that I included in my 
first post showed the my bios was doing the right thing.  My problem was 
that I was using CONFIG_HIGHMEM4G, which is what the KConfig help 
message told me to do.  After switching to CONFIG_HIGHMEM64G the OS was 
able to map all of my ram.

             total       used       free     shared    buffers     cached
Mem:       4016768    3924312      92456          0     360132    3030336
-/+ buffers/cache:     533844    3482924
Swap:      5116692       2676    5114016

Thanks to those with the correct advice.  I'm sure I would have got this 
by trying each memory model in turn, but at least now I know what is 
going on.

Tom

