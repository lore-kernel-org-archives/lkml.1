Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbYD0SJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbYD0SJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbYD0SJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:09:25 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49457 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbYD0SJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:09:25 -0400
Date: Sun, 27 Apr 2008 20:09:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all architectures
Message-ID: <20080427180957.GA25964@uranus.ravnborg.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org> <20080427174714.GB2252@cs181133002.pp.htv.fi> <20080427180007.GB28483@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427180007.GB28483@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:00:07PM -0400, Christoph Hellwig wrote:
> On Sun, Apr 27, 2008 at 08:47:14PM +0300, Adrian Bunk wrote:
> > What I want instead:
> > - we continue to force the compiler to always inline with "inline"
> > - we remove the inline's in .c files and make too big functions in 
> >   headers out-of-line
> 
> It doesn't matter whether we use inline or always_inline to force
> inlining of a function, that's just syntactical sugar.

inline => the developer hints the compiler that it may
          be a good idea to inline this function

always_inline => the developer tell gcc that for some obscure reasons
                 MUST always inline uses of this function

> What is rather
> annoying is that with the config option we'd have something marked
> inline without actually meaning it's inline.
With the config option we pass the inline hint to gcc (if enabled).
So with the config option we have the possibility to pass a _hint_ to
gcc about inlining.

Before the config option there were no difference between
static int alwyas_inline foo() {}
and
static int inline foo() {}

With the config option we now have a situation where they actually
differ as they should do (assuming gcc > 4.x).

> And what's even worse
> is that this is depending on a user-visible config option which is
> entirely stupid.
So you say that it is safe to assume all places where we really need
always_inline are annotedted such - and we do not need a simple
config option that the user can uncheck.
Fine by me - I prefer the simpler solution.

	Sam
