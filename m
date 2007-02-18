Return-Path: <linux-kernel-owner+w=401wt.eu-S1751114AbXBRD7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbXBRD7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 22:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbXBRD7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 22:59:32 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46937 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXBRD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 22:59:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<200702162045.58857.arnd@arndb.de>
	<20070216195256.GE2572@flint.arm.linux.org.uk>
	<m1k5yhb00g.fsf@ebiederm.dsl.xmission.com>
	<1171747222.5644.143.camel@localhost.localdomain>
Date: Sat, 17 Feb 2007 20:58:26 -0700
In-Reply-To: <1171747222.5644.143.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Sun, 18 Feb 2007 08:20:22 +1100")
Message-ID: <m1zm7c9kwt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>
>> We might need this.  But I don't think we need reference counting in
>> the traditional sense.  For all practical purpose we already have
>> dynamic irq allocation and it hasn't proven necessary.  I would
>> prefer to go to lengths to avoid having to expose that kind of
>> an issue to driver code.
>
> I think we do need proper refcounting, but I also think that most
> drivers will not need to see it.
>
> For example, a PCI driver will most probably just do something along the
> lines of the existing request_irq(pdev->irq), the liftime of pdev->irq
> is managed by the PCI core.
>
> Same goes with MSIs imho, the MSI core can manage the lifetime
> transparently.

Yes.  I'm optimistic that we won't find a case where refcounting will
be needed.

Eric
