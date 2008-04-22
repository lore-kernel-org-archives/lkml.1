Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbYDVVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbYDVVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYDVVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:37:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49037 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456AbYDVVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:37:18 -0400
Date: Tue, 22 Apr 2008 22:36:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Message-ID: <20080422213621.GC21435@flint.arm.linux.org.uk>
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk> <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221359360.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 02:05:29PM -0700, Linus Torvalds wrote:
> On Tue, 22 Apr 2008, Russell King wrote:
> > That was my initial approach as well, which got shot down by Andrew
> > Morton and others as being unacceptable.
> 
> Hmm. While I in general support the notion of trying to compile drivers on 
> as wide a variety as hardware as possible, if that HTC_PASIC3 thing really 
> is a PXA-only piece of hardware, I don't really see the point of not 
> making the config file accurately represent that.
> 
> That said, as far as I can tell, the compile failure is because of this 
> line:
> 
> 	#include <asm/arch/pxa-regs.h>
> 
> and I cannot for the life of me see _why_ it tries to include that header 
> file. It seems to compile fine on x96-64 if you just remove that include, 
> and while I still think it should depend on ARCH_PXA just because it makes 
> no sense _not_ to, I do wonder why that include is there in the first 
> place.
> 
> Hmm?

I think we've settled this in one of my replies to Randy.

However, I think there's a bigger issue here.

[I'm not including all the details here about the timing - since you
know the timing of my emails to you, the only thing left out is that
Andrew told me about this problem on Sunday Morning (UK time).]

My kernel work pattern is Saturday to Monday inclusive and Thursday.
I believe yours is to avoid Saturday through into most of Monday.
This unfortunately means that we currently have almost no overlap,
and very few consecutive days where issues from the previous day
can be resolved.

In light of that, given my request on Monday not to pull my tree,
should I have deleted the for-linus head at the same time to prevent
the pull occuring if you (as has become apparant) didn't read the
message?

I rather guessed that you hadn't pulled my tree by then, but I wasn't
100% sure - sometimes you've pulled my tree but not pushed yours out
for a few days.

It's really the "not knowing" which has caused this issue - had I
known positively that you hadn't pulled my tree I could have prepared
a replacement tree with all the (now numerous) cockups fixed.  Had I
known you had pulled my tree, I would've been able to queue up the
various fixes and had that branch ready to go by Monday evening.

To be really frank, I'm beginning to wonder whether using git is such
a good idea - at least if I was sending you a stream of patches then
all I'd needed to have done was forward you the relevant patches as
fixes to the previous set - and I wouldn't care whether you'd applied
the previous set at that point.

But with git, it has to be known what you're doing at your end before
I can make a decision about how to fix issues at my end.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
