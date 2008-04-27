Return-Path: <linux-kernel-owner+w=401wt.eu-S1763028AbYD0SOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028AbYD0SOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbYD0SOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:14:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYD0SOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:14:14 -0400
Date: Sun, 27 Apr 2008 14:14:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
	architectures
Message-ID: <20080427181411.GA31667@infradead.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org> <20080427180957.GA25964@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427180957.GA25964@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:09:57PM +0200, Sam Ravnborg wrote:
> With the config option we pass the inline hint to gcc (if enabled).
> So with the config option we have the possibility to pass a _hint_ to
> gcc about inlining.
> 
> Before the config option there were no difference between
> static int alwyas_inline foo() {}
> and
> static int inline foo() {}
> 
> With the config option we now have a situation where they actually
> differ as they should do (assuming gcc > 4.x).

As Linus mentioned the hint doesn't make any sense because gcc will
get it wrong anyway.  In fact when you look at kernel code it tends
to inline the everything and the kitchensink as long as there's just
one caller and this bloat the stack but doesn't inline where it needs
to.  Better don't try to mess with that and do it explicit.

> So you say that it is safe to assume all places where we really need
> always_inline are annotedted such - and we do not need a simple
> config option that the user can uncheck.

I don't say it is that, it certainly isn't on powerpc and probably most
other architectures right now, because only x86 got the fixup so far.
But making it a user-visible option instead of an architecture opt
in/out selection doesn't make any sense.

