Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYGaUOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYGaUOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYGaUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:14:07 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:29812 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYGaUOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:14:05 -0400
Date: Thu, 31 Jul 2008 22:14:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080731201444.GC25305@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <20080731182315.GA18060@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731182315.GA18060@linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 07:23:15PM +0100, Ralf Baechle wrote:
> On Mon, Jul 28, 2008 at 10:05:00PM +0200, Sam Ravnborg wrote:
> 
> > The traditional location of the arch specific Makefiles
> > has been at:
> > 
> > 	include/asm-$ARCH
> > 
> > But as suggested by several people over time and lately
> > by Linus in the following post:
> > http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
> > 
> > is is suggested to move the arch specific files under arch/
> > and for the header files this is arch/$ARCH/include.
> > 
> > So I have hacked up support for this in kbuild so
> > for the simpler cases a simple move of header files as
> > in:
> > 	git mv include/asm-$ARCH arch/$ARCH/include/asm
> > 
> > is enough.
> > 
> > If Linus will accept it then I think -rc1 is a perfect
> > time to do it as people has less stuff pending touching
> > the header files that are moved.
> > Validation is easy - does the usual configs build?
> > 
> > For the archs that plays games with symlinks this is a
> > splendid opportunity to get rid af these.
> > The receipe is simple:
> > Use 
> > 	KBUILD_CFLAGS += -Iarch/$ARCH/include/$CPU
> > 
> > to select the CPU and then do a copy of the header files
> > like this:
> > 
> > 	git mv include/asm-$ARCH/$CPU arch/$ARCH/include/$CPU/cpu
> > 
> > Then the code can continue to use:
> > 
> > 	#include <cpu/foo.h>
> > 
> > I already converted sparc to use arch/sparc/include -
> > while I merged the header files for sparc and sparc64.
> > This change is already upstream.
> > 
> > And for SH I posted a receipe which you can read here:
> > http://lkml.org/lkml/2008/7/28/83
> > 
> > It is SH specific but anyway pretty generic.
> > 
> > I am limited in time and resources at the moment but I
> > would be glad to help out as time permits should there
> > be any questions.
> 
> I just did the necessary changes for MIPS and the first testbuild is running
> successfully so far.
> 
> One of the ugly things in the MIPS makefiles is the use of platform-
> specific headers in include/asm-mips/mach-* which contain platform specific
> headers.  Ideally those should be included through something like
> <mach/somefile.h> or <plat/something.h> and I think a directory like
> arch/$ARCH/$PLATFORM/include/plat/foobar.h could be a good place in the
> new scheme?  I assume other platforms have similar issues with subplatforms,
> processor sub-architectures etc.?

I like it. And rmk suggested something similar so I dragged you into
that thread (on linux-arm-kernel). Let's continue there.

	Sam
