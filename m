Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXJaQ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXJaQ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXJaQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:27:57 -0400
Received: from zachs.place.org ([66.219.59.183]:33916 "EHLO place.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbXJaQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:27:56 -0400
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Paul Jimenez <pj@place.org>, rgooch@atnf.csiro.au,
       linux-kernel@vger.kernel.org, pj@place.org
Subject: Re: [PATCH] mtrr use type bool 
In-reply-to: <47289EE3.8080706@student.ltu.se> 
References: <20071031035718.A1D9E8B2A@place.org> <47289EE3.8080706@student.ltu.se>
Comments: In-reply-to Richard Knutsson <ricknu-0@student.ltu.se>
   message dated "Wed, 31 Oct 2007 16:27:31 +0100."
Date: Wed, 31 Oct 2007 11:27:55 -0500
From: Paul Jimenez <pj@place.org>
Message-Id: <20071031162755.981728B2D@place.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, Oct 31, 2007, Richard Knutsson writes:
>>  		if (likely(replace < 0))
>>  			usage_table[i] = 1;
>>  		else {
>> -			usage_table[i] = usage_table[replace] + !!increment;
>> +			usage_table[i] = usage_table[replace] + increment;
>>   
>This seems a bit strange, using a boolean as an integer (yes I know, it 
>works but semantically...). What about:
>
>+			usage_table[i] = usage_table[replace];
>+			usage_table[i] += increment ? 1 : 0;
>? 

I've got no strong feelings either way.

  usage_table[i] = usage_table[replace];
  if (increment) usage_table[i]++; 

...would work just fine too.

>> index 289dfe6..54347e9 100644
>> --- a/arch/x86/kernel/cpu/mtrr/mtrr.h
>> +++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
>> @@ -2,10 +2,8 @@
>>   * local mtrr defines.
>>   */
>>  
>> -#ifndef TRUE
>> -#define TRUE  1
>> -#define FALSE 0
>> -#endif
>> +#include <linux/types.h>
>> +#include <linux/stddef.h>
>>   
>Isn't those included by default?

Are they?  I couldn't find the #includes so I put them in, figuring that at worst cpp will strip them.

>The rest looks good :)
>
>Richard Knutsson


Cool.  Any idea what maintainer I should send this to?  I'm not sure Mr. Gooch is still actively the mtrr maintainer.  Maybe the new x86 maintainers could apply it?

  --pj

