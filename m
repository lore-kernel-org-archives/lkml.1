Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXFFIdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXFFIdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXFFId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:33:29 -0400
Received: from gw.goop.org ([64.81.55.164]:39870 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXFFId2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:33:28 -0400
Message-ID: <4666714E.3090506@goop.org>
Date: Wed, 06 Jun 2007 01:33:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Xen-devel <xen-devel@lists.xensource.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] [patch 21/33] xen: Xen SMP guest support
References: <20070522140941.802382212@goop.org>	<20070522141252.611887616@goop.org> <46667FA3.76E4.0078.0@novell.com>
In-Reply-To: <46667FA3.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> --- a/arch/i386/xen/time.c
>> +++ b/arch/i386/xen/time.c
>> @@ -105,17 +105,15 @@ static void get_runstate_snapshot(struct
>> 	preempt_enable();
>> }
>>
>> -static void setup_runstate_info(void)
>> +static void setup_runstate_info(int cpu)
>> {
>> 	struct vcpu_register_runstate_memory_area area;
>>
>> -	area.addr.v = &__get_cpu_var(runstate);
>> +	area.addr.v = &per_cpu(runstate, cpu);
>>
>> 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
>> 			       smp_processor_id(), &area))
>>     
>
> Shouldn't this be 'cpu' rather than 'smp_processor_id()'?
>   

Yes.  I'd noticed that, thought it got fixed later in the series, and
looks like I ultimately got confused.  Not sure when this crept in; it
has been correct in the past.

    J
