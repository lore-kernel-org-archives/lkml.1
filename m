Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbXERC6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbXERC6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXERC56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:57:58 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:38946 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbXERC56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:57:58 -0400
Date: Thu, 17 May 2007 22:57:48 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
In-Reply-To: <1179455959.2859.527.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com>
References: <20070517143200.GA30850@lst.de>  <1179413443.3642.49.camel@sauron>
 <20070517145653.GA968@lst.de>  <1179414590.3642.69.camel@sauron> 
 <20070517102931.6bbbad1a.akpm@linux-foundation.org>  <pan.2007.05.17.20.30.30@free.fr>
 <1179455959.2859.527.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, David Woodhouse wrote:
> On Thu, 2007-05-17 at 20:30 +0000, Matthieu CASTET wrote:
> > On Thu, 17 May 2007 10:29:31 -0700, Andrew Morton wrote:
> > 
> > > On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy
> > > <dedekind@infradead.org> wrote:
> > > 
> > > umm..  I'd say what you've done in there is an improvement to the
> > > exiting stuff: getting gcc to check it is better than having to use
> > > sparse.
> > > 
> > > I'd have expected gcc to generate poorer code with your approach but I'm
> > > showing zero text size changes from Christoph's patch (gcc-4.1 and
> > > gcc-3.4.5).
> > > 
> > >
> > On which arch did you try ?
> > X86 where unaligned access are ok ?
> > 
> > On arch that don't support aligned access, packed struct access will be 
> > done byte per byte (but it could be the expected behavior if there 
> > unaligned access).
> 
> When I tested this on ARM, the output for je32_to_cpu et al was fine.
> For _other_ structures where I'd used __attribute__((packed)) to be
> safe, gcc would emit code to handle unaligned loads. But not in the
> simple case where the struct has only one member.
> 
> Are you suggesting that this has changed since I did my testing?

Wouldn't the appropriate test be to demonstrate that the same program text 
opcodes are generated in both cases for all architectures? If that's not 
the case, even if the generation isn't -worse-, it shows that the compiler 
is doing different things with each, which means different versions of the 
compiler could do different things with it, and all of a sudden another 
nice programming construct which helps compile-time issues ends up 
increasing the number of cases where compiler differences generate faster 
or slower kernels with the same code, whereas in the test cases it was "no 
better, no worse" so deemed fine.
