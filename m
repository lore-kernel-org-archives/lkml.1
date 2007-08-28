Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXH1ImN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXH1ImN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXH1Ilz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:41:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44985 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbXH1Ily (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:41:54 -0400
Date: Tue, 28 Aug 2007 10:43:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Gabriel C <nix.or.die@googlemail.com>,
       linux-kernel@vger.kernel.org, Olaf Hering <olh@suse.de>,
       netdev@vger.kernel.org
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070828084315.GB27022@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <20070828003704.deed71ae.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828003704.deed71ae.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 12:37:04AM -0700, Andrew Morton wrote:
> On Mon, 27 Aug 2007 23:27:43 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, Aug 22, 2007 at 03:33:27PM +0200, Gabriel C wrote:
> > >...
> > > WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
> > >...
> > 
> > Patch below.
> > 
> > > Regards,
> > > 
> > > Gabriel
> > 
> > cu
> > Adrian
> > 
> > 
> > <--  snip  -->
> > 
> > 
> > This patch makes the 64bit integers on 32bit architectures usable for
> > all C parsers that know about "long long".
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> Given that this patch (hopefully) fixes a problem in the current net-2.6.24
> tree, I'm inclined to slip it into mainline immediately.
> 
> But I'd like a better description, please.  Which "non-gcc parser" are we
> talking about here?  Something under ./scripts/.  Well, please identify it,
> and describe what the problem is, and how the proposed patch will address
> it.
> 
> Let's cc Sam too, as I guess he's the guy whose code just broke.

If my analysis is correct then genksyms fails to produce a CRC for div64_64 because
genksyms does not know the __extension__ keyword.
And this patch just paper over the real bug wich is in genksyms - right?

So we should fix the root cause here.

Googeling I did not find a good description of where __extension__ can be
used so I fail to see where in the parse.y file I shal add the keyword.
I think __extension__ may be used both as a part of an expression AND
as part of a typedef (as in this case) but I wonder if this is where it is limited
to be used.
I would like to have this sorted out so we do not do a half-backed solution,
and the proposed patch as it just paper over the real bug is no good.

	Sam
