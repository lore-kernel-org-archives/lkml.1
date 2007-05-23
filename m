Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXEWRbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXEWRbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759453AbXEWRbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:31:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31691 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbXEWRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:31:46 -0400
Message-ID: <46547A65.30200@mvista.com>
Date: Wed, 23 May 2007 10:31:17 -0700
From: Kevin Hilman <khilman@mvista.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Kevin Hilman <khilman@mvista.com>, Daniel Walker <dwalker@mvista.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable preemption
References: <20070522230128.891568116@mvista.com> <1179876320.15427.214.camel@imap.mvista.com> <1179877296.6122.74.camel@vence.hilman.org> <20070523092232.GA9482@flint.arm.linux.org.uk> <1179936837.7051.11.camel@vence.hilman.org> <20070523162500.GA1976@flint.arm.linux.org.uk>
In-Reply-To: <20070523162500.GA1976@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Wed, May 23, 2007 at 09:13:57AM -0700, Kevin Hilman wrote:
>> On Wed, 2007-05-23 at 10:22 +0100, Russell King wrote:
>>> In which case shouldn't it be at the end of the function so it includes
>>> the write buffer handling as well?
>>>
>>> However, I think I agree with Daniel on this one.  I don't see the point
>>> of the preempt_disable() here.
>> Note that my patch simply adds an enable to match the disable added by
>> the -rt patch.  I'm not sure where the disable originally came from, but
>> there are disable/enable pairs scattered throughout tlbflush.h in the
>> -rt patch.
>>
>> If this one isn't necessary, then the others probably are not either.
>> In most cases there are 2 mcr instructions inside the critical section.
>> One for the dsb() and the other for the actual function.
>>
>> Russell, is there a reason any of these sections should be atomic?
> 
> I don't see any reason for them to be - when switching to another process
> we'll generally do a full TLB flush anyway, so what's the point in making
> these flushes atomic?

OK, I've removed the locally and will be doing some testing on OMAP2
(ARMv6.)  I'll submit a patch to Ingo if things look good.

In the meantime, my previous fix is still necessary for -rt to even work
on ARM.

Kevin
