Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXJKNxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXJKNxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbXJKNxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:53:00 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40737 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbXJKNw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:52:58 -0400
Date: Thu, 11 Oct 2007 22:52:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071011135227.GA20994@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
References: <200710101722.21126.rob@landley.net> <20071011113931.GB8393@uranus.ravnborg.org> <Pine.LNX.4.64.0710111443530.3729@anakin> <200710110827.12631.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710110827.12631.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 08:27:12AM -0500, Rob Landley wrote:
> On Thursday 11 October 2007 7:46:47 am Geert Uytterhoeven wrote:
> > On Thu, 11 Oct 2007, Sam Ravnborg wrote:
> > > On Thu, Oct 11, 2007 at 09:25:19AM +0200, Geert Uytterhoeven wrote:
> > > > BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.
> > >
> > > For "make headers_install" this is not good.
> > > But I see there is confliting usages here.
> > > 1) current functionality makes it easy to build a cross compiled m68k
> > >
> > > Btw. if you did:
> > > CROSS_COMPILE ?= m68k-linux-
> > >
> > > then I could do:
> > > export CROSS_COMPILE=my-m68k-linux-
> > > make
> > >
> > > and still get the expected result.
> >
> > That won't work, cfr. http://lkml.org/lkml/2007/5/6/58.
> 
> Reading the patch in that link, recent cross compilers from _where_?  
> Buildroot?  Cross-tools?  Gentoo embedded?  Cross Linux From Scratch?  My 
> Firmware Linux project?
> 
> You assume they all use the same name, yet your patch changes them from one 
> default name to another default name, presumably due to a gcc version change 
> becoming increasingly political about the GNU/Linux/Dammit thing...
> 
> None of the other targets I've tried attempt to _supply_ a default.  Just like 
> the Linux kernel errors out early in the build if you distclean and then try 
> to run "make" without having run config first.  It doesn't run "defconfig" 
> for you and continue on in that case.  But m68k, uniquely, assumes it knows 
> what you want to do when you didn't tell it.  Other targets do not do this.
> 
Many platforms used to do this. For most of them it didn't end up being
useful given all of the target variant, so they just got removed. If
that's not the case for m68k and it's still useful for people there, then
there's no reason to remove it. If you want to overload it you are free
to, but Geert is right that headers_install shouldn't be calling the
cross compiler if it has no dependency on it. Fixing bugs is preferable
to fixing symptoms.
