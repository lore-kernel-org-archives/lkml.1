Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYFBHYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYFBHYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYFBHYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:24:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38823 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYFBHYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:24:34 -0400
Date: Mon, 2 Jun 2008 08:24:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080602072403.GA20222@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
	scottwood@freescale.com, linuxppc-dev@ozlabs.org,
	alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
	tpiepho@freescale.com
References: <1211852026.3286.36.camel@pasglop> <20080526.184047.88207142.davem@davemloft.net> <1211854540.3286.42.camel@pasglop> <20080526.192812.184590464.davem@davemloft.net> <1211859542.3286.46.camel@pasglop> <alpine.LFD.1.10.0805270833060.2958@woody.linux-foundation.org> <1211922621.3286.80.camel@pasglop> <alpine.LFD.1.10.0805271421570.2958@woody.linux-foundation.org> <1211924335.3286.89.camel@pasglop> <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 02:55:56PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 28 May 2008, Benjamin Herrenschmidt wrote:
> > 
> > A problem with __raw_ though is that they -also- don't do byteswap,
> 
> Well, that's why there is __readl() and __raw_readl(), no?
> 
> Neither does ordering, and __raw_readl() doesn't do byte-swap.

This is where the lack of documentation causes arch maintainers a big
problem.  None of the semantics of __raw_readl vs __readl vs readl are
documented _anywhere_.  If you look at x86 as a template, there's no
comments there about what the different variants are supposed to do
or not do.

So it's left up to arch maintainers to literally guess what should be
done.  That's precisely what I did when I implemented ARMs __raw_readl
and friends.  I guessed.

And it was only after I read a few mails on lkml which suggested that
readl and friends should always be LE that ARMs readl implementation
started to use le32_to_cpu()... before that it had always been native
endian.  Again, lack of documentation...

So, can the semantics of what's expected from these IO accessor
functions be documented somewhere.  Please?  Before this thread gets
lost in the depths of time?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
