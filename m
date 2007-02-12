Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXBLEwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXBLEwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 23:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXBLEwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 23:52:16 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44674 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXBLEwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 23:52:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: What are the real ioapic rte programming constraints?
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
Date: Sun, 11 Feb 2007 21:51:05 -0700
In-Reply-To: <Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com> (Zwane
	Mwaikambo's message of "Sun, 11 Feb 2007 17:05:12 -0800 (PST)")
Message-ID: <m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo <zwane@infradead.org> writes:

> On Sun, 11 Feb 2007, Eric W. Biederman wrote:
>
>> > 2.15.2 PCI Express* Legacy INTx Support and Boot Interrupt
>> > http://download.intel.com/design/chipsets/datashts/30262802.pdf
>> 
>> Ouch.  And this kind of thing isn't exactly uncommon.
>> 
>> However if we have the irqs also disabled in the i8259 we should
>> be safe from actually receiving this interrupt (even if it generates
>> bus traffic), and when we enable the irq since it is level triggered  
>> we should still get an interrupt message.
>>
>> It isn't immediately obvious where the i8259 irq enable/disable
>> happens.  So i"m having trouble auditing that bit of code.
>>
>> Plus we can get very strange things like the irq number changing
>> and the sharing rules being different when going through the i8259.
>> So irqN may be irqM when going through the i8259.
>> 
>> As long as we aren't using anything on the i8259 including the timer
>> in ExtINT mode we can disable every interrupt pin and not worry about
>> interrupts from that source.
>
> We do the 8259 mask in setup_IO_APIC_irq. does anyone have access to an 
> E7520/E7320 system for testing?

I think I do, I need to double check. 

The thing is this logic is different in that it uses INTx instead of pins
but otherwise is quite standard for chipsets and their IOAPICs.  I'm not
at all certain this behavior is what the original concern was about.
The description is enough different you may have found a completely
different set of behavior we have to worry about.

Since the legacy/non legacy behavior is common invoked by the ioapic
mask bit working with just about any recent chipset should get a taste
of that.  But I will still try and dig up an E7520 and see what
happens.

Eric
