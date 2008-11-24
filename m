Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYKXTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYKXTSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYKXTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:18:23 -0500
Received: from gw.goop.org ([64.81.55.164]:43595 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYKXTSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:18:22 -0500
Message-ID: <492AFDFC.1020305@goop.org>
Date: Mon, 24 Nov 2008 11:18:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
References: <patchbomb.1226603398@abulafia.goop.org>	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>	<m1y6ze87w6.fsf@frodo.ebiederm.org> <4925D762.6040406@goop.org>	<m1prkpj3nl.fsf@frodo.ebiederm.org> <49260BE7.1080909@goop.org> <m1tza1hffa.fsf@frodo.ebiederm.org>
In-Reply-To: <m1tza1hffa.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> Yes, I suppose we can statically partition the irq space.  In fact the original
>> 2.6.18-xen dom0 kernel does precisely that, but runs into limitations because of
>> the compile-time limit on NR_IRQS in that kernel.  If we move to a purely
>> dynamically allocated irq space, then having a sparse allocation if irqs becomes
>> reasonable again, for msis and vectorless Xen interrupts.
>>
>>     
>>> The difference is that the xen sources are not delivered using vectors.  The cpu
>>> vector numbers we do hide and treat as an implementation detail.  And I am totally
>>> happy not going through the vector allocation path.
>>>
>>>       
>> Right.  And in the physical irq event channel case, the vector space is managed
>> by Xen, so we need to use Xen to allocate the vector, then program that into the
>> appropriate place in the ioapic.
>>     
>
> We should be able to share code with iommu for irqs handling, at first glance you
> are describing a pretty similar problem.  Now I don't know think the interrupt
> remapping code is any kind of beauty but that seems to be roughly what you
> are doing with Xen domU.  I certainly think with some careful factoring
> we can share the ioapic munging code.  And the code to pick how we program
> the ioapics.
>   

Notwithstanding the possibility that there'll be general changes to x86 
interrupt handing in the future, do you have any objection to my patches 
as they stand?  Ingo would like to see your and/or hpa's ack before 
accepting them.

Should I repost them?

Thanks,
    J
