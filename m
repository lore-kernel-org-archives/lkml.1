Return-Path: <linux-kernel-owner+w=401wt.eu-S1763058AbYD0Sgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763058AbYD0Sgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759636AbYD0Sgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:36:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbYD0Sgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:36:41 -0400
Date: Sun, 27 Apr 2008 14:36:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427183631.GC23828@infradead.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org> <20080427181411.GA31667@infradead.org> <20080427183131.GA26937@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427183131.GA26937@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:31:31PM +0200, Sam Ravnborg wrote:
> The tendency is that gcc inline *more than we whish* - not less.
> Which is why we have noinline - to cover the cases where we do not
> want stuff inlined.

Which is exactly the wrong way around.  noinline should be the default.
But that's probaby no fixable without touching gcc or doing ugly hacks
as in xfs.

> What the patch in question does is to make a difference
> between always_inle and inline.
> Previously they were the same. With the patch applied and
> with a gcc > 4.0 inline is now a hint.
> 
> Did you actually read the patch?

Yes.  As as I said I think having them the same, or rather only
having one of them makes more sense than having a hint in addition to
force.

> If you read the patch you will see that the architectures that
> want to enable this has to do an explicit HAVE_CC_INLINE_HINT
> so powerpc is not impacted by this until they request it.
> Exactly the reason why this was not widely enabled in the
> first place (but implemnted in a too x86 specific way).

Yes, and that part of your patch is a good thing, and makes it at
least sensible unlike ingos.  The patch in this mail is the one
we should probably go for short term, although the right way to
sort it out is the long one, aka goign through all users of inline
and deciding what they really want.

