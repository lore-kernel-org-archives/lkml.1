Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbXKNUPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbXKNUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbXKNUPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:15:44 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:4186 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbXKNUPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:15:43 -0500
Date: Wed, 14 Nov 2007 21:13:52 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeff Garzik <jeff@garzik.org>
cc: Brian Gerst <bgerst@didntduck.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
In-Reply-To: <47352FC9.9080701@garzik.org>
Message-ID: <Pine.LNX.4.64.0711140606430.1818@scrub.home>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org>
 <47352DF2.5000409@didntduck.org> <47352FC9.9080701@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 9 Nov 2007, Jeff Garzik wrote:

> > > I switch between other cross-compiled arches (alpha, usually) on the
> > > makefile command line
> > > 
> > > Yes, I know other 32/64-bit arches require .config editing.  That
> > > doesn't change the basic fact that this is a workflow regression.
> > > 
> > >     Jeff
> > 
> > You can use:
> > 
> > make i386_defconfig
> > make x86_64_defconfig
> 
> Does that work for alpha too?
> 
> 
> > In any other case you'd be editing the .config anyways.
> 
> No, that's a logic rathole down which I will not follow :)
> 
> You can make any argument along those lines command line usage is really an
> art, not a science.  Its a user interface, and that involves human taste
> rather than logic.
> 
> I've been bouncing between architectures using ARCH= for years, and my fingers
> and brain have been trained.  It's just disappointing and a pain to change
> this nice user interface that has served so well for years.

I disagree that this is a regression. You can still bounce between archs 
as before, but the fact is that these are not separate archs anymore. The 
sooner we'll get used to the fact the better.
You also don't bounce between archs just by changing ARCH, you also have 
to reconfigure the kernel and that's there you can change the 64bit 
option. This means for the normal user not much is changing and from an 
experienced user I'd expect to know the difference.

If we look at this as a new feature, we have to look at what is needed to 
support this properly. Should the arch name imply certain config options? 
This wouldn't have to be limited to 64BIT - SMP or MMU could be other 
options. I think it would also make sense to hide the corresponding config 
option, otherwise one could change an option, which is a little later 
ignored anyway. Another question would be if and how it affects other 
information like uname information.

What I'd like to avoid is to add potential cruft, which is only used to 
avoid the inevitable to properly learn how to configure the kernel. A user 
interface has a lot to do with logic, especially consistency - an 
inconsistent mess also doesn't taste very good.

bye, Roman
