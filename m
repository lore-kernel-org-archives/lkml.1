Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbXE3PeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbXE3PeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXE3PeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:34:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbXE3PeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:34:07 -0400
Date: Wed, 30 May 2007 08:31:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465D43A0.8040307@garzik.org>
Message-ID: <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Jeff Garzik wrote:
> 
> You snipped the key part of my response, so I'll say it again:
> 
> Event rings (a) most closely match what is going on in the hardware and (b)
> often closely match what is going on in multi-socket, event-driven software
> application.

I have rather strong counter-arguments:

 (a) yes, it's how hardware does it, but if you actually look at hardware, 
     you quickly realize that every single piece of hardware uses a 
     *different* ring interface.

     This should really tell you something. In fact, it may not be rings 
     at all, but structures with more complex formats (eg the USB 
     descriptors).

 (b) yes, event-driven software tends to use some data structures that are 
     sometimes approximated by event rings, but they all use *different* 
     software structures. There simply *is* no common "event" structure: 
     each program tends to have its own issues, it's own allocation 
     policies, and its own "ring" structures.

     They may not be rings at all. They can be priority queues/heaps or 
     other much more complex structures.

> To echo Uli and paraphrase an ad, "it's the interface, silly."

THERE IS NO INTERFACE! You're just making that up, and glossing over the 
most important part of the whole thing! 

If you could actually point to something specific that matches what 
everybody needs, and is architecture-neutral, it would be a different 
issue. As is, you're just saying "memory-mapped interfaces" without 
actually going into enough detail to show HOW MUCH IT SUCKS.

There really are very few programs that would use them. We had a trivial 
benchmark, the only function of which was to show usage, and here Ingo and 
Evgeniy are (once more) talking about bugs in that one months later.

THAT should tell you something.

Make poll/select/aio/read etc faster. THAT is where  the payoffs are.

In fact, if somebody wants to look at a standard interface that could be 
speeded up, the prime thing to look at is "readdir()" (aka getdents). 
Making _that_ thing go faster and scale better and do read-ahead is likely 
to be a lot more important for performance. It was one of the bottle-necks 
for samba several years ago, and nobody has really tried to improve it.

And yes, that's because it's hard - people would rather make up new 
interfaces that are largely irrelevant even before they are born, than 
actually try to improve important existing ones.

			Linus
