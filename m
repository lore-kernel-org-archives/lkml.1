Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXB1NCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXB1NCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXB1NCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:02:08 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:47772 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190AbXB1NCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:02:04 -0500
In-Reply-To: <200702281324.19884.arnd@arndb.de>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com> <200702280141.51420.arnd@arndb.de> <m14pp6kat9.fsf@ebiederm.dsl.xmission.com> <200702281324.19884.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1d80d625c286a59844874e000756350c@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Date: Wed, 28 Feb 2007 14:02:00 +0100
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> pci: each device/function has a unique irq, drivers need not know
>>>      about it afaics.
>> Then there is msi and with msi-x you can have up to 4K irqs.
>
> I have to admit I still don't really understand how this works
> at all. Can a driver that uses msi-x have different handlers
> for each of those interrupts registered simultaneously?

Yes.  It doesn't have to, though.

> I would expect that instead there should be only one 'struct irq'
> for the device, with the handler getting a 12 bit number argument.

Why?  The device really generates many different interrupts,
why hide this fact.

>> For talking to user space I expect we will have numbers for a long 
>> time
>> to come yet.
>
> I was wondering about that. Do you only mean /proc/interrupts or
> are there other user interfaces we need to worry about?

There's the IRQ affinity stuff too.

> For /proc/interrupts, what could break if we have interrupt numbers
> only local to each controller and potentially duplicate numbers
> in the list? It's good to be paranoid about changes to proc files,
> but I can definitely see value in having meaningful interrupt
> numbers in there instead of making up a more or less random mapping
> to a flat number space.

Duplicate all this stuff into /sys in a sane format (*) and
wait until userland catches up, then throw away the /proc
interfaces.  It'll take a while, and until that day you will
have to keep *some* interrupt number <-> interrupt bijection.
Userland tools that think they know what interrupt number
should be what are dead already.

(*) i.e., exposing the interrupt tree as a tree, cascaded
controllers and all.


Segher

