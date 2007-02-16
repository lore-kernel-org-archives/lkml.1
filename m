Return-Path: <linux-kernel-owner+w=401wt.eu-S1945926AbXBPPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945926AbXBPPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945939AbXBPPgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:36:17 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60750 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945922AbXBPPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:36:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<200702161316.41237.ak@suse.de>
Date: Fri, 16 Feb 2007 08:35:43 -0700
In-Reply-To: <200702161316.41237.ak@suse.de> (Andi Kleen's message of "Fri, 16
	Feb 2007 13:16:41 +0100")
Message-ID: <m17iuidsj4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> I expect the most it makes sense to aim for 2.6.22 are the genirq
>> changes so the internal arch code is passing struct irq_desc
>> everywhere internally. 
>
> Are there any livetime issues with passing pointers around? 
> e.g. what happens on APIC hotunplug etc.? We don't necessarily
> support that yet, but for a big interface change it should 
> be probably kept in mind first.

Ouch.  Let's consider the case of pci device (using msi's) hot unplug.
That case we theoretically support today but I'm not certain we account
for it.

The only real issue (I can imagine) would come from something that is
not part of the device driver using the irq, as the device and
everything associated with it should have the same lifetime rules.
(You can't unplug an ioapic without unplugging the device it is
connected to).

So the things to consider would be things like /proc/interrupts and
/proc/irq.  I think we already have some kind of revoke in place when
the irq goes away so it probably makes sense just to make that revoke
solid and immediate.

So I can't imagine any real lifetime issues that would cause us
problems with a pointer.

Eric
