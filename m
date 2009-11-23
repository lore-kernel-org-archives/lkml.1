Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZKWScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZKWScr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZKWScq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:32:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZKWScq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:32:46 -0500
Date: Mon, 23 Nov 2009 19:32:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Put printk buffer in video ram
Message-ID: <20091123183220.GB24482@elte.hu>
References: <1258855506.3153.1.camel@maxim-laptop>
 <20091122023237.GA6572@nowhere>
 <20091122082511.GC24558@elte.hu>
 <1258892101.3231.20.camel@maxim-laptop>
 <1258938089.3134.22.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258938089.3134.22.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sun, 2009-11-22 at 14:15 +0200, Maxim Levitsky wrote: 
> > On Sun, 2009-11-22 at 09:25 +0100, Ingo Molnar wrote: 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > On Sun, Nov 22, 2009 at 04:05:06AM +0200, Maxim Levitsky wrote:
> > > > > After doing some successful debugging by placing printk buffer in video
> > > > > ram, here I publish cleaned version of it.
> > > > > 
> > > > > I discovered that on my system video ram isn't cleared on reboot, and I
> > > > > took advantage of that by placing printk buffer directly there.
> > > > > This allows to capture oopses/panicks almost from everywhere.
> > > > > It is also very simple to setup.
> 
> Few more thoughts:
> 
> First of all, if I implement this as a console driver, I won't be able
> to capture all kernel log, but only from the point I register the
> console.

Adding an early console driver would solve this, right?

There's an earlyprintk=..,keep option that also allows such a console 
driver to be active during normal system operation - that way you could 
get this feature with a single console driver.

> My implementation, also isn't set up very early, but I copy already
> written log to the memory buffer.
> 
> Problem of automatic unregistration isn't a problem, its just a feature,
> I could skip using.
> 
> Secondary, I found out that system ram isn't cleared ether on my
> notebook, however I found out that I can't reserve small memory range
> with 'memmap' kernel parameter. System just panics.
> I used for reference 'memmap=2M$0x60000000'
> My system has 2GB of memory.
> 
> I could reserve the memory same way using the code, but it would
> probably fail in same way. Also I could try early reservations, but I am
> not sure I can reserve _any_ address range. I test this.
> 
> I think that patches to put printk buffer at predefined area in system
> ram were once posted on LKML.

The way to early-reserve memory on x86 is to use find_e820_area() + 
reserve_early().

	Ingo
