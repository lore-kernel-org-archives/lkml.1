Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZAKOyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZAKOyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZAKOyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:54:17 -0500
Received: from web.keli.cz ([77.48.235.227]:47030 "EHLO web.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZAKOyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:54:16 -0500
Message-ID: <496A080B.30609@century.cz>
Date: Sun, 11 Jan 2009 15:54:03 +0100
From: Petr Titera <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Build error on latest git
References: <4969C096.9060909@century.cz> <4969DEA0.5020301@century.cz>	 <3f9a31f40901110506v646bd599q863be03accbfd8b2@mail.gmail.com> <1231679335.3244.1.camel@jaswinder.satnam>
In-Reply-To: <1231679335.3244.1.camel@jaswinder.satnam>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm that was my first try to fix this. But unfortunatelly it fails in 
arch/x86/kernel/apic.c right after that.

Petr

Jaswinder Singh Rajput napsal(a):
> On Sun, 2009-01-11 at 18:36 +0530, Jaswinder Singh Rajput wrote:
>   
>> On Sun, Jan 11, 2009 at 5:27 PM, Petr Titera <P.Titera@century.cz> wrote:
>>     
>>> Going through source it seems to me (still building) that it is caused by
>>> including asm/smp.h only if build with CONFIG_SMP. This patch seems to fix
>>> this
>>>
>>> diff --git a/include/linux/smp.h b/include/linux/smp.h
>>> index b824669..fd51bb9 100644
>>> --- a/include/linux/smp.h
>>> +++ b/include/linux/smp.h
>>> @@ -11,6 +11,8 @@
>>> #include <linux/list.h>
>>> #include <linux/cpumask.h>
>>>
>>> +#include <asm/smp.h>
>>> +
>>> extern void cpu_idle(void);
>>>
>>>       
>> No, this is wrong.
>>
>> asm/smp.h should only be included when CONFIG_SMP is defined.
>>
>> I will send fix of this.
>>
>>     
>
> Here is the temporary fix, later on I will remove non-smp data from
> smp.h
>
> Subject: [PATCH] x86: mpparse.c fix compilation error
>
> Impact: fix compilation error
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/mpparse.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index 8385d4e..79dae60 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -27,6 +27,7 @@
>  #include <asm/e820.h>
>  #include <asm/trampoline.h>
>  #include <asm/setup.h>
> +#include <asm/smp.h>
>  
>  #include <mach_apic.h>
>  #ifdef CONFIG_X86_32
>   

