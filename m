Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXERLxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXERLxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXERLxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:53:08 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:35375 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbXERLxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:53:07 -0400
Date: Fri, 18 May 2007 07:52:39 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
In-Reply-To: <1179458274.2859.538.camel@shinybook.infradead.org>
Message-ID: <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com>
References: <20070517143200.GA30850@lst.de>  <1179413443.3642.49.camel@sauron>
 <20070517145653.GA968@lst.de>  <1179414590.3642.69.camel@sauron> 
 <20070517102931.6bbbad1a.akpm@linux-foundation.org>  <pan.2007.05.17.20.30.30@free.fr>
  <1179455959.2859.527.camel@shinybook.infradead.org> 
 <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com>
 <1179458274.2859.538.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, David Woodhouse wrote:
> On Thu, 2007-05-17 at 22:57 -0400, John Anthony Kazos Jr. wrote:
> > Wouldn't the appropriate test be to demonstrate that the same program text 
> > opcodes are generated in both cases for all architectures? 
> 
> No, empirical testing with the compiler is never the _correct_ thing to
> do. It's just expedient.
> 
> > If that's not the case, even if the generation isn't -worse-, it shows
> > that the compiler is doing different things with each, which means
> > different versions of the compiler could do different things with it,
> 
> Well yes, but even it _is_ generating precisely the same output today,
> there's no reason why the compiler shouldn't behave differently under a
> different phase of the moon.
> 
> The _correct_ thing to do is act upon my mutterings at the time I
> removed the '__attribute__((packed))' from various JFFS2 structures to
> improve the generated code on ARM -- actually implement an attribute for
> GCC which has the same "don't insert any padding" meaning, but without
> the unwanted "assume arbitrary alignment" implications.

Out of curiosity, why would a compiler ever insert padding in a structure 
that has all its elements properly-aligned?

> It'd actually be nice if GCC knew about endianness too. I don't want to
> have to do:
> 
>    *x = le32_to_cpu(cpu_to_le32(*x) + 5);
> 
> I just want 
> 
>   uint32_t __attribute__((littleendian)) *x;
> 
>   *x += 5;
> 
> I know we can hack around it for masks, with '*x |= cpu_to_le32(X_BAR);'
> and such like, and we can load it into local native-endian variables and
> then copy it back again later -- but it's better just to let the
> compiler know what's going on and do its own optimisation. Especially on
> architectures which have 'load-and-swap' or 'store-and-swap'
> instructions.
