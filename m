Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZBCNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZBCNQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBCNQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:16:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43076 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZBCNQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:16:04 -0500
Date: Fri, 30 Jan 2009 21:37:12 +0100
From: Pavel Machek <pavel@suse.cz>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
Message-ID: <20090130203712.GB1253@ucw.cz>
References: <1233106614.3256.6.camel@localhost.localdomain> <200901281337.52294.arnd@arndb.de> <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick> <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain> <1233172994.6717.56.camel@brick> <4980CD51.70601@zytor.com> <1233179884.6717.59.camel@brick> <alpine.LFD.2.00.0901281411490.3123@localhost.localdomain> <1233182444.6717.68.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233182444.6717.68.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-01-28 14:40:44, Harvey Harrison wrote:
> On Wed, 2009-01-28 at 14:13 -0800, Linus Torvalds wrote:
> > 
> > On Wed, 28 Jan 2009, Harvey Harrison wrote:
> > >
> > > Use ifdef __i486__ to ensure the BSWAP instruction is available
> > > on 32-bit x86.
> > > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > > ---
> > > HPA,
> > > 
> > > I'm afraid my knowledge of gcc compiler flags for various models is
> > > lacking, I used i486 as suggested, just wanted to make sure I understood
> > > you corectly.
> > 
> > I really don't think this works.
> > 
> > Try this:
> > 
> > 	cpp -dM -m32 -march=pentium t.c | grep i486
> > 
> > and see the marked absense of __i486__ anywhere.
> > 
> > At least CONFIG_X86_BSWAP gives the right behaviour for the kernel.
> 
> You're right, it doesn't work.  Perhaps just exporting the bswap version
> all the time and i386-only people can worry about patching it out?

And break i386 in a nasty way? Please don't.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
