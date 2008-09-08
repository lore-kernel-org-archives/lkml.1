Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYIHP35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYIHP35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYIHP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:29:49 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58811 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbYIHP3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:29:49 -0400
Message-ID: <48C544EA.9050106@sgi.com>
Date: Mon, 08 Sep 2008 08:29:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 11/13] genapic: reduce stack pressuge in io_apic.c step
 3 target_cpus
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>	 <20080906235038.421559000@polaris-admin.engr.sgi.com> <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com>
In-Reply-To: <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bert Wesarg wrote:
> On Sun, Sep 7, 2008 at 01:50, Mike Travis <travis@sgi.com> wrote:
>>  * Step 3 "target_cpus" of cleaning up io_apic.c modifies the TARGET_CPUS
>>    interface to pass a pointer to the returned mask for arch X86_64,
>>    removing yet another "cpumask_t variable on the stack".
>>
>>        target_cpus = TARGET_CPUS;
>>
>>    becomes:
>>
>>        TARGET_CPUS(target_cpus);
>>
>>    For x86_32 this is expanded to:
>>
>>        target_cpus = (genapic->target_cpus());
>>
>>    For x86_64 this is expanded to:
>>
>>        target_cpus = (genapic->target_cpus)(&(target_cpus));
> But its expended to:
>          (genapic->target_cpus)(&(target_cpus));

Umm, right, my cut and paste error...

Thanks,
Mike
> 
>> -#define TARGET_CPUS      (genapic->target_cpus())
>> +#define TARGET_CPUS(retval) (genapic->target_cpus)(&(retval))
> 
> 
>> +#ifdef CONFIG_X86_64
>> +#define TARGET_CPUS(retval)      (genapic->target_cpus)(&(retval))
>> +#else
>> +#define TARGET_CPUS(retval)      retval = (genapic->target_cpus())
>> +#endif
> 
> Bert

