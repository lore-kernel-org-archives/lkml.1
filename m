Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXB1NaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXB1NaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbXB1NaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:30:14 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42443 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbXB1NaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:30:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<1171844753.5644.174.camel@localhost.localdomain>
	<m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
	<200702280141.51420.arnd@arndb.de>
	<m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
	<1172650184.11949.96.camel@localhost.localdomain>
Date: Wed, 28 Feb 2007 06:28:38 -0700
In-Reply-To: <1172650184.11949.96.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Wed, 28 Feb 2007 09:09:44 +0100")
Message-ID: <m1abyyif7d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> What I really object to is not the irq numbers.  As an arbitrary number
>> does not impose limits.  What I object to is drivers that can't handle the
>> full range of numbers, and the limits imposed upon those numbers when
>> you require them to be indexes into an array.
>> 
>> For talking to user space I expect we will have numbers for a long time
>> to come yet.
>
> I wouldn't bother too much about going into bus specific bits like
> irq_request(dev, ...). Well, actually, I _do_ think it's a good thing to
> pass the struct device to irq_request but that's a different issue
> completely.

Well irq_request is probably a bit late for associating an irq with
a struct device.  And I don't see how to get the device name from that
but making that association wouldn't be a bad thing.

> I think bus types should provide bus specific helpers to obtain the
> struct irq *'s for a given device on that bus, but the API for
> requesting/freeing them shall remain generic.

Yes.  But if you can do a good job of wrapping them so a driver
wouldn't need to care at all that could help simplify drivers and
remove one more tidbit of complexity from drivers.

However for a widespread change.  The less you have to think about
it the more quickly you can get it completed.  So I would rather
do several wide spread changes in succession, that I don't have to
think about much to do (i.e.  the change mostly meets the obviously
correct requirement).  Then to do one single change that I have to
think about harder to accomplish.

The more thinking comes into the picture the more you open yourself up
to breaking something by accident because it wasn't clear how the code
should be changed, and the more it slows down the conversion.

Conversions where we have had to think about things are notoriously slow
to complete.  Even if they are a good thing to do.  The examples I can
think of are the kthread API and the DMA api.  Last I checked there
were still a few drivers in the kernel using virt_to_bus...

I don't really get the benefits I'm after unless the conversion can
actually be completed for everything.  So the more I have to think about
any one piece the less I intend to do it.

Eric
