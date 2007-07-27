Return-Path: <linux-kernel-owner+w=401wt.eu-S1764277AbXG0UvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764277AbXG0UvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937896AbXG0Uum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:50:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56273
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S937894AbXG0Uul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:50:41 -0400
Date: Fri, 27 Jul 2007 13:50:37 -0700 (PDT)
Message-Id: <20070727.135037.52167499.davem@davemloft.net>
To: arjan@infradead.org
Cc: torvalds@linux-foundation.org, matthew@wil.cx, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQF_DISABLED problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185567116.2711.2.camel@laptopd505.fenrus.org>
References: <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
	<alpine.LFD.0.999.0707261616050.3442@woody.linux-foundation.org>
	<1185567116.2711.2.camel@laptopd505.fenrus.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@infradead.org>
Date: Fri, 27 Jul 2007 13:11:56 -0700

> On Thu, 2007-07-26 at 16:17 -0700, Linus Torvalds wrote:
> > 
> > On Thu, 26 Jul 2007, Linus Torvalds wrote:
> > > 
> > >  (c) "one IRQF_DISABLED means that everything runs disabled". This is 
> > >      quite possibly buggy.
> > 
> > (Side note: I'm not claiming this (or it's mirror image (d)) is really any 
> > better/worse than the current behaviour from a theoretical standpoint, but 
> > at least the current behaviour is _tested_, which makes it better in 
> > practice. So if we want to change this, I think we want to change it to 
> > something that is _obviously_ better).
> 
> my personal preference would actually be to just never enable
> interrupts. It's the fastest solution obviously, the most friendly on
> stack and.. well simplest. Drivers no longer need to play some of the
> games that they do today. And while there is an argument that this may
> introduce a bit of latency... I'm not really convinced.

If you have a "chirpy" serial controller with only a 1 byte
fifo, even a quite reasonable interrupt handler can cause
receive characters to get lost if you disable interrupts during
the entirety of it's execution.

It really is needed.

And it's just plain rude to disable interrupts when it isn't
absolutely necessary.
