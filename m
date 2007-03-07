Return-Path: <linux-kernel-owner+w=401wt.eu-S1422948AbXCGVSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422948AbXCGVSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422996AbXCGVSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:18:54 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51394 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422948AbXCGVSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:18:52 -0500
Message-ID: <45EF2B35.9030708@vmware.com>
Date: Wed, 07 Mar 2007 13:14:29 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei>	 <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com>	 <45EF1C80.50900@goop.org>	 <1173301065.24738.766.camel@localhost.localdomain>	 <45EF2868.8050009@vmware.com> <1173302393.24738.792.camel@localhost.localdomain>
In-Reply-To: <1173302393.24738.792.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 21:18:51.0932 (UTC) FILETIME=[345565C0:01C760FE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 01:19 PM, Thomas Gleixner wrote:
> On Wed, 2007-03-07 at 13:02 -0800, Dan Hecht wrote:
>> On 03/07/2007 12:57 PM, Thomas Gleixner wrote:
>>> On Wed, 2007-03-07 at 12:11 -0800, Jeremy Fitzhardinge wrote:
>>>> Dan Hecht wrote:
>>>>> Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's
>>>>> ours for reference (please excuse any formating issues); it's also
>>>>> lean. We'll send out a proper patch later after some more testing:
>>>> So the interrupt side of the clockevent comes through the virtual apic? 
>>>> Where does evt->handle_event get called?
>>>
>>>>         /* We use normal irq0 handler on cpu0. */
>>>>         time_init_hook();
>>> That's exactly the thing I ranted about before. We keep the historic
>>> view of emulated hardware and just wrap it into enough glue code instead
>>> of doing an abstract design, which just gets rid of those hardware
>>> assumptions at all. That's the big advantage of paravirtualization, but
>>> the current way on paravirt ops is just ignoring this.
>>>
>> Are you saying you would prefer we create our own irq handler something 
>> like this rather than using the standard i386 handlers?
>>
>> irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
>> {
>>     local_event->event_handler(local_event);
>>     return IRQ_HANDLED;
>> }
>>
>> ??  That's fine with me.
> 
> I prefer _ONE_ generic abstract implementation of a clock event, which
> can be used by all hypervisors. Please keep all your wiring and ideas of
> how to best emulate a i386 system away from the kernel as far as you
> can.
> 
> Please sit down with the other hypervisor folks and define the five
> functions you need to interact between clockevents and the particular
> hypervisor and implement it once.
> 
> Then you can change and evolve your idea of how handle them best in your
> hypervisor code, where it belongs.
> 

Okay, I guess we are essentially back to the "XEN & VMI" thread.  Let's 
just keep that discussion in one place.
