Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbXJaU4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbXJaU4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXJaU4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:56:36 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56929 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbXJaU4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:56:35 -0400
Message-ID: <4728EA74.5080505@student.ltu.se>
Date: Wed, 31 Oct 2007 21:49:56 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Paul Jimenez <pj@place.org>
CC: rgooch@atnf.csiro.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtrr use type bool
References: <20071031035718.A1D9E8B2A@place.org> <47289EE3.8080706@student.ltu.se> <20071031162755.981728B2D@place.org>
In-Reply-To: <20071031162755.981728B2D@place.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jimenez wrote:
> On Wednesday, Oct 31, 2007, Richard Knutsson writes:
>   
>>>  		if (likely(replace < 0))
>>>  			usage_table[i] = 1;
>>>  		else {
>>> -			usage_table[i] = usage_table[replace] + !!increment;
>>> +			usage_table[i] = usage_table[replace] + increment;
>>>   
>>>       
>> This seems a bit strange, using a boolean as an integer (yes I know, it 
>> works but semantically...). What about:
>>
>> +			usage_table[i] = usage_table[replace];
>> +			usage_table[i] += increment ? 1 : 0;
>> ? 
>>     
>
> I've got no strong feelings either way.
>
>   usage_table[i] = usage_table[replace];
>   if (increment) usage_table[i]++; 
>
> ...would work just fine too.
>   
Mm, looks even better IMO. (with the usage_table[i]++; on its own line ;) )
>   
>>> index 289dfe6..54347e9 100644
>>> --- a/arch/x86/kernel/cpu/mtrr/mtrr.h
>>> +++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
>>> @@ -2,10 +2,8 @@
>>>   * local mtrr defines.
>>>   */
>>>  
>>> -#ifndef TRUE
>>> -#define TRUE  1
>>> -#define FALSE 0
>>> -#endif
>>> +#include <linux/types.h>
>>> +#include <linux/stddef.h>
>>>   
>>>       
>> Isn't those included by default?
>>     
>
> Are they?  I couldn't find the #includes so I put them in, figuring that at worst cpp will strip them.
>   
They are #included by linux/kernel.h... But it may be as well to include 
them, avoiding the dependence on the overgrown kernel.h.
>   
>> The rest looks good :)
>>
>> Richard Knutsson
>>     
>
>
> Cool.  Any idea what maintainer I should send this to?  I'm not sure Mr. Gooch is still actively the mtrr maintainer.  Maybe the new x86 maintainers could apply it?
>   
Sorry, not really. Did a 'git log arch/x86/kernel/cpu/mtrr/', but it 
seems there is no loges before the move to arch/x86/... Anyway, you may 
like to add Thomas Gleixner and Ingo Molnar, they have signed-off 3 out 
of the 4 remaining commits (otherwise they should know where to send it).

Richard Knutsson

