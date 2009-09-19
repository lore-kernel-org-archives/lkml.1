Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZISJUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZISJUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbZISJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:20:07 -0400
Received: from [195.41.46.235] ([195.41.46.235]:47150 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZISJUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:20:06 -0400
Date: Sat, 19 Sep 2009 11:20:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/5] kbuild: Set -fconserve-stack option for gcc 4.5
Message-ID: <20090919092003.GA25916@merkur.ravnborg.org>
References: <200909141018.915641783@firstfloor.org> <20090914201811.187B3B1757@basil.firstfloor.org> <20090914143615.9ee47a1a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914143615.9ee47a1a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 02:36:15PM -0700, Andrew Morton wrote:
> On Mon, 14 Sep 2009 22:18:11 +0200 (CEST)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > 
> > The upcomming gcc 4.5 has a new -fconserve-stack option 
> > that tells the inliner to take stack frame size in account.
> > Set it if the compiler supports it.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > 
> > ---
> >  Makefile |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6.31-rc3-ak/Makefile
> > ===================================================================
> > --- linux-2.6.31-rc3-ak.orig/Makefile
> > +++ linux-2.6.31-rc3-ak/Makefile
> > @@ -575,6 +575,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-s
> >  # revert to pre-gcc-4.4 behaviour of .eh_frame
> >  KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
> >  
> > +# conserve stack if available
> > +KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
> 
> Do we have any info about what effects this option has upon the
> generated code?  Text size changes, runtime stack usage changes, etc?

I merged this despite the relevant questions above was not answered.
But maybe we should wait until Andi gets back with numbers?

	Sam
