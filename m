Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYCNVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYCNVRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYCNVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:17:10 -0400
Received: from gw.goop.org ([64.81.55.164]:42008 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbYCNVRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:17:09 -0400
Message-ID: <47DAEAD8.9060402@goop.org>
Date: Fri, 14 Mar 2008 14:15:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com>
In-Reply-To: <1205523826.7441.1242464129@webmail.messagingengine.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Fri, 14 Mar 2008 11:07:55 -0700, "Jeremy Fitzhardinge"
> <jeremy@goop.org> said:
>   
>> Alexander van Heukelum wrote:
>>     
>>> x86: merge the simple bitops and move them to bitops.h
>>>
>>> Some of those can be written in such a way that the same
>>> inline assembly can be used to generate both 32 bit and
>>> 64 bit code.
>>>
>>> For ffs and fls, x86_64 unconditionally used the cmov
>>> instruction and i386 unconditionally used a conditional
>>> branch over a mov instruction. In the current patch I
>>> chose to select the version based on the availability
>>> of the cmov instruction instead. A small detail here is
>>> that x86_64 did not previously set CONFIG_X86_CMOV=y.
>>>   
>>>       
>> Looks good in general.  What's left in bitops_{32,64}.h now?
>>     
>
> Thanks for taking a look!
>
> bitops_{32,64}.h are getting pretty empty ;)
>
> Both contain find_first_bit/find_first_zero_bit, i386 has them inlined,
> x86_64 has an ugly define to select between small bitmaps (inlined) and
> an out-of-line version. I think they should be unified much like how
> find_next_bit and find_next_zero_bit work now (in x86#testing).
>
> Both define fls64(), but i386 uses a generic one and x86_64 defines
> one all by itself. The generic one is currently not suitable for
> use by 64-bit archs... that can change.
>
> x86_64 defines ARCH_HAS_FAST_MULTIPLIER, i386 not. This affects a
> choice of generated code in the (generic) hweight function. It would
> be nice if that could move to some other file.
>
> x86_64 has a mysterious inline function set_bit_string, which is
> only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
> do with it.
>
>   
>> (Some comments below.)
>>     
>
> --- %< ---
>
>   
>>> +#ifdef __KERNEL__
>>> +/**
>>> + * ffs - find first bit set
>>> + * @x: the word to search
>>> + *
>>> + * This is defined the same way as
>>> + * the libc and compiler builtin ffs routines, therefore
>>> + * differs in spirit from the above ffz() (man ffs).
>>>       
>> This comment seems wrong.  My "man ffs" says that it returns 1-32 for 
>> non-zero inputs, and 0 for a zero input.  This function returns 0-31, or 
>> -1 for a zero input.
>>     
>
> Seems, indeed. You missed the "return r + 1;" ;-)
>   

Indeed I did.

    J
