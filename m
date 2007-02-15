Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXBORtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXBORtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030371AbXBORtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:49:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030367AbXBORtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:49:08 -0500
Date: Thu, 15 Feb 2007 09:42:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070215163704.GA32609@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> 
> Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about. Period
> . // <- wrapped one

No, I really think you're wrong.

In many ways, the interfaces and especially data structures are *more* 
important than the code.

The code we can fix. The interfaces, on the other hand, we'll have to live 
with forever.

So complex interfaces that expose lots of implementation detail are not a 
good thing, and it's _not_ the last thing you want to think about. Complex 
interfaces with a lot of semantic knowledge seriously limit how you can 
fix things up later.

In contrast, simple interfaces that have clear and unambiguous semantics 
and that can be explained at a conceptual level are things that you can 
often implement in many different ways. So the interface isn't the bottle 
neck: you may have to have a "backwards compatibility layer" for it 

> If system is designed that with API changes it breaks - that system sucks 
> wildly and should be thrown away. Syslets do not suffer from that.

The syslet code itself looks fine. It's the user-visible part I'm not 
convinced about.

I'm just saying: how would use use this for existing programs?

For something this machine-specific, you're not going to have any big 
project written around the "async atom" code. So realistically, the kinds 
of usage we'd see is likely some compile-time configuration option, where 
people replace some specific sequence of code with another one. THAT is 
what we should aim to make easy and flexible, I think. And that is where 
interfaces really are as important as code.

We know one interface: the current aio_read() one. Nobody really _likes_ 
it (even database people would apparently like to extend it), but it has 
the huge advantage of "being there", and having real programs that really 
care that use it today. 

Others? We don't know yet. And exposing complex interfaces that may not be 
the right ones is much *worse* than exposing simple interfaces (that 
_also_ may not be the right ones, of course - but simple and 
straightforward interfaces with obvious and not-very-complex semantics are 
a lot easier to write compatibility layers for if the internal code 
changes radically)

		Linus
