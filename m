Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZCOQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZCOQc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZCOQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:32:49 -0400
Received: from gw.goop.org ([64.81.55.164]:42347 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZCOQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:32:49 -0400
Message-ID: <49BD2DAE.50204@goop.org>
Date: Sun, 15 Mar 2009 09:32:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: trampoline.c cleanup
References: <1237045494.4546.22.camel@ht.satnam> <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903141718120.29264@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 14 Mar 2009, Jaswinder Singh Rajput wrote:
>
>   
>> Subject: [PATCH] x86: trampoline.c cleanup
>>
>> Impact: cleanup
>>
>>  - fix style problems
>>     
>
> Err. This patch is a style problem itself.
>  
>   
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>> ---
>>  arch/x86/kernel/trampoline.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
>> index 808031a..e3b1f2e 100644
>> --- a/arch/x86/kernel/trampoline.c
>> +++ b/arch/x86/kernel/trampoline.c
>> @@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
>>  	 * trampoline before removing it. (see the GDT stuff)
>>  	 */
>>  	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
>> -#endif
>> +#endif /* CONFIG_X86_32 */
>>     
>
> There is no need for this useless comment. The #ifdef is 5 lines
> above. Such comments are only helpful in large nested sections.
>   

Not wanting to prolong this sort of boring thread, but I think there's 
definitely wiggle room here.  I tend to put closing comments on #endifs 
even if they're quite close to their #if(def) because the syntax is so 
awful, with no inherent indication of nesting.  And once you have to 
deal with a merge collision, or even just gradual drifting apart of the 
#if/endif, the closing comment becomes very helpful.

Sure, the closing comment adds some noise too, but the fix is to reduce 
the number of #ifdefs.

But in this case, I agree with tglx - the closing comment is pointless, 
because its unlikely that we're going to get #ifdef nesting or any more 
code between the #ifdef/endif pair.

    J
