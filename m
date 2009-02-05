Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZBEFwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZBEFwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBEFvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:51:50 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33093 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZBEFvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:51:50 -0500
Date: Thu, 5 Feb 2009 06:53:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing unistd_no.h and unistd_mm.h export on m68k
Message-ID: <20090205055337.GA30333@uranus.ravnborg.org>
References: <20090204181453.GE26064@csclub.uwaterloo.ca> <20090204183142.GF26064@csclub.uwaterloo.ca> <20090204184659.GG26064@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204184659.GG26064@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 01:46:59PM -0500, Lennart Sorensen wrote:
> On Wed, Feb 04, 2009 at 01:31:42PM -0500, Lennart Sorensen wrote:
> > On Wed, Feb 04, 2009 at 01:14:53PM -0500, Lennart Sorensen wrote:
> > > make header_install fails to include the files unistd_no.h and
> > > unistd_mm.h on m68k, while those two files are included by unistd.h.
> > > 
> > > This patch fixes this by adding these two files to the list of m68k
> > > specific headers to export.
> > > 
> > > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > > 
> > > Signed
> > > diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> > > index 1a922fa..2bb4738 100644
> > > --- a/arch/m68k/include/asm/Kbuild
> > > +++ b/arch/m68k/include/asm/Kbuild
> > > @@ -1,2 +1,2 @@
> > >  include include/asm-generic/Kbuild.asm
> > > -header-y += cachectl.h
> > > +header-y += cachectl.h unistd_no.h unistd_mm.h
> > 
> > Hmm, seems it is actually much worse than I thought.  All _no.h and
> > _mm.h are being missed, making m68k compiles of things like uclibc
> > rather broken.  Yuck.
> 
> So updated patch that makes uclibc actually compile for m68k.
> 
> -- 
> Len Sorensen
> 
> 
> 
> make header_install fails to include the files *_no.h and
> *_mm.h on m68k, while those files are included by the matching *.h
> 
> This patch fixes this by adding these missing files to the list of m68k
> specific headers to export.  With this patch, uclibc compiles again.

Hi Len.

Indeed the *_no.h, *_mm.h is missing from Kbuild.h.
But looking at your patch you added much more than the
missing *_no.h, *_mm.h.
When doing this do it in steps:
1) fix make headers_check
   This is fixed by adding the *_no.h,*_mm.h for files that
   are exported. And that is the files lited in include/asm-generic/Kbuild.asm
   plus the single file listed in the m68k Kbuld file.

2) then as a separate patch export the additional files needed to build
   ulibc.
   Do it file-by-file so you are sure you do not add a single file
   that is not needed. We want to have a minimal set of files exported.

And when you prepare your patch please use one line per header file,
as we do in all the ohter Kbuild files.

	Sam

