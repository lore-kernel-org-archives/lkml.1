Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZJZSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZJZSSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbZJZSSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:18:38 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56693 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752691AbZJZSSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:18:37 -0400
Message-ID: <4AE5E804.9060409@sgi.com>
Date: Mon, 26 Oct 2009 11:18:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andreas Mohr <andi@lisas.de>, Hugh Dickins <hugh@veritas.com>,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233756.941535000@alcatraz.americas.sgi.com> <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
In-Reply-To: <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Adamushko wrote:
> 2009/10/24 Mike Travis <travis@sgi.com>:
>> Limit number of microcode messages of the form:
>>
>> [   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001
>>
>> [ ... ]
>>
>> --- linux.orig/arch/x86/kernel/microcode_intel.c
>> +++ linux/arch/x86/kernel/microcode_intel.c
>> @@ -165,7 +165,9 @@
>>        /* get the current revision from MSR 0x8B */
>>        rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
>>
>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
>> +       if (cpu_num < 4 || !limit_console_output(false))
>> +               printk(KERN_INFO
>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
>>                        cpu_num, csig->sig, csig->pf, csig->rev);
>>
> 
> Hmm, I guess we wouldn't lose a lot by simply removing those messages
> completely. Per-cpu pf/revision is available via /sys anyway.
> 
> Alternatively, we might move the output into
> microcode_core.c::collect_cpu_info() (or even microcode_init_cpu()) so
> that the same logic is also applied for amd and do something as
> following:
> 
> don't print if a cpu info is equal to the info of CPU#0. I guess, any
> non-0 cpu would be even better as the microcode for cpu#0 can be
> loaded by BIOS, if I'm not mistaken. But then we can only be sure
> about the presence of cpu#0.
> 
> Anyway, it's not worthy of any additional complexity so I'd say let's
> just remove the output :-)
> 
> 
> -- Dmitry

I would be more than happy to remove messages but I didn't want to override
the original author's intent on why they choose to add these messages in the
first place.

Plus if you have a 64 or 128 cpu system, it might give you pleasure in seeing
all those cpu messages.  ;-)  Just when it hits around 256 and up that it
really starts getting annoying.

Thanks,
Mike

