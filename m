Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXB1IMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXB1IMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXB1IMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:12:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:60116 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXB1IMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:12:30 -0500
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
In-Reply-To: <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <1171844753.5644.174.camel@localhost.localdomain>
	 <m1abyzl4yw.fsf@ebiederm.dsl.xmission.com>
	 <200702280141.51420.arnd@arndb.de>
	 <m14pp6kat9.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 28 Feb 2007 09:09:44 +0100
Message-Id: <1172650184.11949.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What I really object to is not the irq numbers.  As an arbitrary number
> does not impose limits.  What I object to is drivers that can't handle the
> full range of numbers, and the limits imposed upon those numbers when
> you require them to be indexes into an array.
> 
> For talking to user space I expect we will have numbers for a long time
> to come yet.

I wouldn't bother too much about going into bus specific bits like
irq_request(dev, ...). Well, actually, I _do_ think it's a good thing to
pass the struct device to irq_request but that's a different issue
completely.

I think bus types should provide bus specific helpers to obtain the
struct irq *'s for a given device on that bus, but the API for
requesting/freeing them shall remain generic.

Ben.

