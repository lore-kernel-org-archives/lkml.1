Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbXCALC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbXCALC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXCALC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:02:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:53706 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933242AbXCALCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:02:55 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <m1649mie1c.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <200702280141.51420.arnd@arndb.de>
	 <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
	 <200702281324.19884.arnd@arndb.de>
	 <m1649mie1c.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 11:47:27 +0100
Message-Id: <1172746048.11949.103.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Similarly, in a pci device, one could imagine that the
> > struct pci_driver contains a irq_handler_t member that
> > is registered from the pci_device_probe() function
> > if present.
> 
> Yes.  There is some potential there.  Although we would have to go
> through an extra hoop to make it a pci specific handler type.

Beware with that approach though. If you are on a shared IRQ line, when
do you start getting called when an IRQ happen (possibly for the "other"
device) ? As soon as you are bound to the device ? But that means
potentially before the driver internal data structures are fully
initialized...

I like the driver having in control the "hooking" of the irq handler,
thus, when it starts being capable of handling interrupts (even if they
aren't initiated by that driver's device).



