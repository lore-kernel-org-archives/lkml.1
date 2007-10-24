Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbXJXV2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbXJXV2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXJXV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:27:54 -0400
Received: from ns2.mvista.com ([63.81.120.158]:14578 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbXJXV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:27:53 -0400
Message-ID: <471FB8D2.5060208@ct.jp.nec.com>
Date: Wed, 24 Oct 2007 14:27:46 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, hbabu@us.ibm.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] x86: add lapic_shutdown for x86_64
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com> <20071024062933.GA4622@in.ibm.com>
In-Reply-To: <20071024062933.GA4622@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Oct 19, 2007 at 06:21:11PM -0700, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> ---
>>  arch/x86/kernel/apic_64.c |   14 ++++++++++++++
>>  include/asm-x86/apic_64.h |    1 +
>>  2 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
>> index f47bc49..f28ccb5 100644
>> --- a/arch/x86/kernel/apic_64.c
>> +++ b/arch/x86/kernel/apic_64.c
>> @@ -287,6 +287,20 @@ void disable_local_APIC(void)
>>  	apic_write(APIC_SPIV, value);
>>  }
>>
>> +void lapic_shutdown(void)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (!cpu_has_apic)
>> +		return;
>> +
>> +	local_irq_save(flags);
>> +
>> +	disable_local_APIC();
>> +
>> +	local_irq_restore(flags);
>> +}
>> +
>>  /*
> 
> Do we really have to introduce this function for 64bit? I remember some
> issues were faced on i386 w.r.t kernel enabling the LAPIC against the
> wishes of BIOS hence kernel was disabling it while shutting down. No
> such problems were reported for x86_64 hence this function existed only
> for i386.

Thanks for the comment. I didn't know the issues, so I'd simply added
this function for unification.

> If that is the case, probably we don't have to introduce lapic_shutdown()
> for x86_64. Instead call lapic_shutdown() for X86_32, and disble_local_APIC()
> otherwise?

I will do that. I was thinking which is good when posting these patches.

Thanks
Hiroshi Shimamoto
