Return-Path: <linux-kernel-owner+w=401wt.eu-S1767841AbXCJPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767841AbXCJPuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXCJPuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:50:44 -0500
Received: from gw.goop.org ([64.81.55.164]:59324 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472AbXCJPun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:50:43 -0500
Message-ID: <45F2D3CE.1060008@goop.org>
Date: Sat, 10 Mar 2007 07:50:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question about periodic clocks
References: <45F1ED30.5070402@goop.org> <1173516061.24738.1148.camel@localhost.localdomain>
In-Reply-To: <1173516061.24738.1148.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Good point. I never thought about that and we set the period in the
> clock event device itself. You are right, the clockevents layer should
> hand over the period either with the set_mode call or seperately.
> Probably with the set_mode call, as it is needed exactly there and we
> don't want to have a "if (dev->mode == XXX)" check in set_next_event().
>
> I look into this.
>
>   

So, in the meantime, the period is 1/HZ?

I also have a question about clockevent cpumasks.  I was using the lapic
clockevent as a model, but as I understand it there's a lapic per CPU,
which explains why it registers a clockevent per cpu with that cpu alone
in the cpumask.

The Xen timer is a bit different; I guess more like hpet.  There's a
single (virtual-)machine-wide timer, which is "owned" by the last cpu
with programmed it; ie, that cpu is the one which gets the resulting
event interrupt.  Does this mean I should register a single clockevent
device with a cpumask of CPU_MASK_ALL?  Or should I constrain it to a
single cpu?

There's a comment in hpet.c saying

		 * Start hpet with the boot cpu mask and make it
		 * global after the IO_APIC has been initialized.

but I don't see any place where the hpet cpumask is updated.

Thanks,
    J

