Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYHTAkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYHTAkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYHTAkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:40:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37252 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYHTAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:40:03 -0400
Message-ID: <48AB6628.8060409@oracle.com>
Date: Tue, 19 Aug 2008 17:32:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] merge io_apic_xx.c -- fix
References: <1218881249-3028-1-git-send-email-yhlu.kernel@gmail.com>	<20080816133554.GB11063@elte.hu>	<20080819152156.c79f31e4.randy.dunlap@oracle.com>	<86802c440808191724j68f50b1fx7b2488963fcf96fd@mail.gmail.com> <20080819172757.63b16451.akpm@linux-foundation.org>
In-Reply-To: <20080819172757.63b16451.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 19 Aug 2008 17:24:08 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> 
>> On Tue, Aug 19, 2008 at 3:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> On Sat, 16 Aug 2008 15:35:54 +0200 Ingo Molnar wrote:
>>>
>>>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>>
>>>>>     merge io_apic_xx.c
>>>>>
>>>>> Thanks
>>>> applied to tip/irq/sparseirq - thanks!
>>>
>>> Are there patches in the io_apic series to fix these warnings in linux-next?? ::
>>>
>>>
>>> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>>> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64
>>>
>>>
>>> and
>>>
>>> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>>> linux-next-20080819/arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>>>
>> No
> 
> yes
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
> arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
> 
> No need for casting here - we know what type u64 has.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/kernel/io_apic_32.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN arch/x86/kernel/io_apic_32.c~arch-x86-kernel-io_apic_32c-fix-printk-warnings arch/x86/kernel/io_apic_32.c
> --- a/arch/x86/kernel/io_apic_32.c~arch-x86-kernel-io_apic_32c-fix-printk-warnings
> +++ a/arch/x86/kernel/io_apic_32.c
> @@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(v
>  	}
>  
>  	icr = apic_icr_read();
> -	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
> -	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
> +	printk(KERN_DEBUG "... APIC ICR: %08Lx\n", icr);
> +	printk(KERN_DEBUG "... APIC ICR2: %08Lx\n", icr >> 32);
>  
>  	v = apic_read(APIC_LVTT);
>  	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
> _


Crud, I had a copy-paste error.  There are also printk format warnings
in io_apic_64.c:

linux-next-20080819/arch/x86/kernel/io_apic_64.c:1284: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
linux-next-20080819/arch/x86/kernel/io_apic_64.c:1285: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'long unsigned int


-- 
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
