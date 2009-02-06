Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZBFOxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZBFOxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZBFOxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:53:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBFOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:53:21 -0500
Date: Fri, 6 Feb 2009 14:51:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, ralf@linux-mips.org, dhowells@redhat.com,
       matthew@wil.cx, chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090206145119.GB13758@n2100.arm.linux.org.uk>
References: <1233385816.17794.16.camel@localhost.localdomain> <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com> <alpine.LFD.2.00.0902051101040.3247@localhost.localdomain> <20090205191907.GA27422@elte.hu> <1233886017.3463.26.camel@localhost.localdomain> <20090206022025.GA8317@elte.hu> <1233929922.3209.6.camel@localhost.localdomain> <20090206142134.GA13758@n2100.arm.linux.org.uk> <1233930860.3209.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233930860.3209.13.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:04:20PM +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-02-06 at 14:21 +0000, Russell King - ARM Linux wrote:
> > On Fri, Feb 06, 2009 at 07:48:42PM +0530, Jaswinder Singh Rajput wrote:
> > > diff --git a/include/linux/types.h b/include/linux/types.h
> > > index 712ca53..c30973a 100644
> > > --- a/include/linux/types.h
> > > +++ b/include/linux/types.h
> > > @@ -1,6 +1,7 @@
> > >  #ifndef _LINUX_TYPES_H
> > >  #define _LINUX_TYPES_H
> > >  
> > > +#ifndef __ASSEMBLY__
> > >  #ifdef	__KERNEL__
> > >  
> > >  #define DECLARE_BITMAP(name,bits) \
> > > @@ -212,5 +213,5 @@ struct ustat {
> > >  };
> > >  
> > >  #endif	/* __KERNEL__ */
> > > -
> > > +#endif /*  __ASSEMBLY__ */
> > >  #endif /* _LINUX_TYPES_H */
> > 
> > So no point including this file in assembly with this patch - the ifndef
> > disables the entire file.
> 
> Truth Table of linux/types.h :
> 
> If Assembly then N
> otherwise Y
> 
> what your table says.

If the entire file is not suitable for assembly, don't include the file
in assembly files.  Nice and simple, and no need to add additional ifdefs.
