Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYE1VZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYE1VZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYE1VZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:25:19 -0400
Received: from gw.goop.org ([64.81.55.164]:47227 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbYE1VZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:25:17 -0400
Message-ID: <483DCD97.20103@goop.org>
Date: Wed, 28 May 2008 22:24:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <200805251000.10205.yhlu.kernel@gmail.com>	 <alpine.LFD.1.10.0805271744080.3295@apollo.tec.linutronix.de>	 <483C70F9.2030901@goop.org>	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>	 <483C7BB0.6080901@goop.org>	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>	 <483C8157.7080702@goop.org>	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>	 <483D2D8A.5040800@goop.org> <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
In-Reply-To: <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>> ===================================================================
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -1266,6 +1266,15 @@
>>                add_preferred_console("hvc", 0, NULL);
>>        }
>>
>> +       /*
>> +        * Reserve Xen bits:
>> +        *  - mfn_list
>> +        *  - xen_start_info
>> +        * See comment above "struct start_info" in <xen/interface/xen.h>
>> +        */
>> +       reserve_early(__pa(xen_start_info->mfn_list),
>> +                     __pa(xen_start_info->pt_base), "XEN");
>> +
>>     
>
> can we use e820 entries for that? So the domain builder could have
> several entries for E820_RAM and E820_RESERVED...
>   

Yeah, seems reasonable.  I'll try it out.

> will need x86_64_start_kernel there, maybe we should change all name
> to x86_start_kernel

We can do that later.  For now it's better to give them distinct names.

    J
