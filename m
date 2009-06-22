Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZFVJje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZFVJje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbZFVJj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:39:26 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42712 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZFVJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:39:25 -0400
Date: Mon, 22 Jun 2009 11:41:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] fbdev: work around old compiler bug
Message-ID: <20090622094143.GA8121@uranus.ravnborg.org>
References: <20090622180420.2e0424e4.sfr@canb.auug.org.au> <20090622183415.46fa786b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622183415.46fa786b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 06:34:15PM +1000, Stephen Rothwell wrote:
> On Mon, 22 Jun 2009 18:04:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > When building with a 4.1.x compiler on powerpc64 (at least) we get
> > this error:
> 
> Ignore this, it causes more problems:
> 
> drivers/video/logo/logo_linux_clut224.c:548: error: logo_linux_clut224_clut causes a section type conflict
> 
> I'll work on a better solution.

I have no time to experiemnt atm.
But I have seen this before.
It happens when we mix up const and non-const stuff.

I would assume the simple solution is to replace _initconst with _initdata
for all users.
If you get it to work with powerpc then it works for everyone (or so it is usually).

	Sam
