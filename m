Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXJKN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXJKN1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXJKN1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:27:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56153
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756972AbXJKN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:27:17 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Date: Thu, 11 Oct 2007 08:27:12 -0500
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
References: <200710101722.21126.rob@landley.net> <20071011113931.GB8393@uranus.ravnborg.org> <Pine.LNX.4.64.0710111443530.3729@anakin>
In-Reply-To: <Pine.LNX.4.64.0710111443530.3729@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710110827.12631.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 7:46:47 am Geert Uytterhoeven wrote:
> On Thu, 11 Oct 2007, Sam Ravnborg wrote:
> > On Thu, Oct 11, 2007 at 09:25:19AM +0200, Geert Uytterhoeven wrote:
> > > On Wed, 10 Oct 2007, Rob Landley wrote:
> > > > From: Rob Landley <rob@landley.net>
> > > >
> > > > Rip out hardwired cross compiler name assumption that only m68k
> > > > makes.
> > > >
> > > > Signed-off-by: Rob Landley <rob@landley.net>
> > > > ---
> > > > When you cross compile, you have to set the prefix CROSS_COMPILE to
> > > > your cross compiler prefix.  You need to do this for all targets
> > > > (arm, mips, ppc, x86-64 on x86, etc).  This is not specific to m68k,
> > > > and this value is supplied _to_ the build, not supplied _by_ the
> > > > build.
> > > >
> > > > The build shouldn't unconditionally overwrite the existing value of
> > > > this variable with one it makes up.  It has no idea what I called my
> > > > cross compiler.
> > >
> > > The build does not unconditionally overwrite the existing value of this
> > > variable. You can specify the name of your cross compiler like this:
> > >
> > >     make CROSS_COMPILE=m68k-linux-
> > >
> > > BTW, m68k-linux-gnu- is the default name for a m68k cross compiler.
> >
> > For "make headers_install" this is not good.
> > But I see there is confliting usages here.
> > 1) current functionality makes it easy to build a cross compiled m68k
> >
> > Btw. if you did:
> > CROSS_COMPILE ?= m68k-linux-
> >
> > then I could do:
> > export CROSS_COMPILE=my-m68k-linux-
> > make
> >
> > and still get the expected result.
>
> That won't work, cfr. http://lkml.org/lkml/2007/5/6/58.

Reading the patch in that link, recent cross compilers from _where_?  
Buildroot?  Cross-tools?  Gentoo embedded?  Cross Linux From Scratch?  My 
Firmware Linux project?

You assume they all use the same name, yet your patch changes them from one 
default name to another default name, presumably due to a gcc version change 
becoming increasingly political about the GNU/Linux/Dammit thing...

None of the other targets I've tried attempt to _supply_ a default.  Just like 
the Linux kernel errors out early in the build if you distclean and then try 
to run "make" without having run config first.  It doesn't run "defconfig" 
for you and continue on in that case.  But m68k, uniquely, assumes it knows 
what you want to do when you didn't tell it.  Other targets do not do this.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
