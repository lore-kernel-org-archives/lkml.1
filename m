Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbXGYOyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbXGYOyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761702AbXGYOyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:54:44 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:33855 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761835AbXGYOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:54:43 -0400
Message-ID: <46A7636F.5010108@pimpmylinux.org>
Date: Wed, 25 Jul 2007 16:51:27 +0200
From: Gabriel C <crazy@pimpmylinux.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Fwd: [PATCH] Fix arch/i386/kernel/nmi.c - 'unknown_nmi_panic_callback'
 declared 'static' but never defined warning
References: <46A3AE06.9030706@googlemail.com>	 <20070724183636.63844865.akpm@linux-foundation.org> <1820d69d0707250657y36c902deya66c2171dade843f@mail.gmail.com>
In-Reply-To: <1820d69d0707250657y36c902deya66c2171dade843f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> ---------- Forwarded message ----------
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: 25.07.2007 03:36
> Subject: Re: [PATCH] Fix arch/i386/kernel/nmi.c -
> 'unknown_nmi_panic_callback' declared 'static' but never defined warning
> To: Gabriel C <nix.or.die@googlemail.com>
> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <
> mingo@redhat.com>, Andi Kleen <ak@suse.de>
> 
> On Sun, 22 Jul 2007 21:20:38 +0200 Gabriel C <nix.or.die@googlemail.com>
> wrote:
> 
>> I get this warning when CONFIG_SYSCTL is not set :
>>
>> ...
>>
>> arch/i386/kernel/nmi.c:52: warning: 'unknown_nmi_panic_callback' declared
> 'static' but never defined
>> ...
>>
>> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
>>
>> ---
>>
>> diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
>> index 03b7f55..cf11121 100644
>> --- a/arch/i386/kernel/nmi.c
>> +++ b/arch/i386/kernel/nmi.c
>> @@ -49,8 +49,9 @@ static unsigned int nmi_hz = HZ;
>>  static DEFINE_PER_CPU(short, wd_enabled);
>>
>>  /* local prototypes */
>> +#ifdef CONFIG_SYSCTL
>>  static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
>> -
>> +#endif
>>  static int endflag __initdata = 0;
> 
> guys, please take a closer look at the code which you're changing?  We can
> obviously move do_nmi_callback() down to above
> __trigger_all_cpu_backtrace() and then do away with this declaration
> altogether.
> 

I will try to do it better next time , sorry.

Oh and I just realized the fix ( whatever it will be at least ) need be done for arch/x86_64/kernel/nmi.c too.


Regards,

Gabriel




