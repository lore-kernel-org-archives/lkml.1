Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXJ2XWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXJ2XWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbXJ2XWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:22:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:57386 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755865AbXJ2XW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:22:29 -0400
Message-ID: <47266B90.8000008@vmware.com>
Date: Mon, 29 Oct 2007 16:24:00 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com> <20071029230213.GA1982@elte.hu>
In-Reply-To: <20071029230213.GA1982@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2007 04:02 PM, Ingo Molnar wrote:
> * Zachary Amsden <zach@vmware.com> wrote:
> 
>> On Mon, 2007-10-29 at 23:48 +0100, Ingo Molnar wrote:
>>> * Zachary Amsden <zach@vmware.com> wrote:
>>> if it's inaccurate why are you exposing it to the guest then? Native 
>>> only uses the TSC if it's safe and accurate to do so.
>> Not every guest support paravirt, but for correctness, all guests 
>> require TSC, which must be exposed all the way up to userspace, no 
>> matter what the efficiency or accuracy may be.
> 
> but if there's a perfect TSC available (there is such hardware) then the 
> TSC _is_ the best clocksource. Paravirt now turns it off unconditionally 
> in essence.
> 

Not really.  In the case hardware TSC is perfect, the paravirt time 
counter can be implemented directly in terms of hardware TSC; there is 
no loss in optimization.  This is done transparently.  And virtual TSC 
can be implemented this way too.

The real improvement that a paravirt clocksource offers over the TSC 
clocksource is that the guest does not need to measure the TSC frequency 
itself against some other constant frequency source (which is 
problematic on a virtual machine).  Instead, the paravirt clocksource 
queries the hypervisor for the frequency of the counter.  As you know, 
with clocksource style kernels, it's important to get this frequency 
correct, or else the guest will have long-term time drift.


