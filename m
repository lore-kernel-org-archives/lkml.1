Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbXGSBiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbXGSBiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXGSBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:37:58 -0400
Received: from waste.org ([66.93.16.53]:35333 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbXGSBh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:37:58 -0400
Date: Wed, 18 Jul 2007 20:37:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719013725.GP11115@waste.org>
References: <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719013955.1bedc423@the-village.bc.nu> <20070719013358.GD29728@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719013358.GD29728@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 03:33:58AM +0200, Andrea Arcangeli wrote:
> On Thu, Jul 19, 2007 at 01:39:55AM +0100, Alan Cox wrote:
> > > About 4k stacks I was generally against them, much better to fail in
> > > fork than to risk corruption. The per-irq stack part is great feature
> > > instead (too bad it wasn't enabled for the safer 8k stacks).
> > 
> > 8K stacks without IRQ stacks are not "safer" so I don't understand your
> > comment ?
> 
> Ouch, see the reports about 4k stack crashes. I agree they're not
> safe w/o irq stacks (like on x86-64), but they're generally safer.

Here's a way to make forward progress on this whole thing:

Turn on irqstacks when using 8k stacks
Detect when usage with 8k stacks would overrun a 4k stack when doing
 our stack switch and do a WARN_ONCE
Fix up the damn bugs

-- 
Mathematics is the supreme nostalgia of our time.
