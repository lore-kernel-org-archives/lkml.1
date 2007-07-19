Return-Path: <linux-kernel-owner+w=401wt.eu-S1763217AbXGSLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763217AbXGSLZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXGSLZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 07:25:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:38942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbXGSLY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 07:24:59 -0400
Date: Thu, 19 Jul 2007 13:24:36 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719112436.GG29728@v2.random>
References: <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org> <20070719001539.GC29728@v2.random> <20070719013955.1bedc423@the-village.bc.nu> <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719013725.GP11115@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:37:25PM -0500, Matt Mackall wrote:
> Turn on irqstacks when using 8k stacks

Indeed.

> Detect when usage with 8k stacks would overrun a 4k stack when doing
>  our stack switch and do a WARN_ONCE
> Fix up the damn bugs

I don't think they're necessarily bugs. IMHO the WARN_ON is better off
at 7k level like it is today with the current STACK_WARN. 4k for a
stack for common code really is small. I doubt you're going to find
obvious culprits that way, more likely you'll have to mangle the code
to call kmalloc for fairly small structures which isn't necessarily a
good thing in the long term. It comes to mind the folio ptes array
that Hugh allocated on the stack in his large PAGE_SIZE patch of jul
2001, that thing like any other local array, would need to be
kmalloced with a 4k stack. With 4k I'm afraid you better not use the
stack for anything but pointers, especially if you run in common code
that may invoke I/O like that.
