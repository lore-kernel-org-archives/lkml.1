Return-Path: <linux-kernel-owner+w=401wt.eu-S1760809AbXKHWD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbXKHWD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbXKHWDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:03:18 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37853 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbXKHWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:03:18 -0500
Date: Thu, 8 Nov 2007 23:04:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 0/6] MN10300: Add the MN10300 architecture to Linux kernel [try #4]
Message-ID: <20071108220455.GB28242@uranus.ravnborg.org>
References: <20071108182937.GA26852@uranus.ravnborg.org> <20071108171612.26590.4348.stgit@warthog.procyon.org.uk> <16966.1194549065@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16966.1194549065@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

> > arch/mn10300/Makefile:
> > 
> > 1) Use KBUILD_CFLAGS & KBUILD_AFLAGS & KBUILD_CPPFLAGS - they
> > have replaced the former xFLAGS.
> 
> Done.  What about ASFLAGS and LDFLAGS?
kbuild does not know anything about ASFLAGS.
In the whole kernel tree I only see frv assign them but the
value is never used.

LDFLAGS has not been changed - it was not such an easy cut.
And we anyway use the linker in much more ways so when to
use it and when not...

> > 4) Drop the symlinks - they are evil...
> > Use a structure like:
> > include/asm-mn10300/asb2303/proc/*.h
> 
> No.  I think all the arch headers should really appear to be #included under
> asm/.  That means that the structure would have to be:
> 
> 	include/asm-mn10300/asb2303/asm/proc/*.h
> 
> That then puts all these header files several levels further down, which isn't
> that good.
I would prefer that any day as replacement for the symlinks.
But as everyone else seems so happy with the symlinks do whatever you prefer.

> > Then you adjust -I include/asm-mn10300/asb2303
> > and no symlinks needed.
> > And if you change processor kbuild will notice
> > and recompile everything.
> 
> That's the only plus, but it's a smaller plus than not interpolating several
> levels of almost empty directory into the paths for the proc- and unit-specific
> headers.
> 
> > No-one else does it this way but mn10300 could show how to do it.
> 
> I could.  Or I could do what everyone else does.
> 
> Actually, what you perhaps ought to do for a start is to move the individual
> include/asm-$ARCH dirs to arch/$ARCH/asm and then you can avoid that symlink
> too.

It will wait until we save ARCH so we can detect
ARCH changes.

> 
> > 5)
> > +zImage: vmlinux
> > +	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
> > +
> > +all: zImage
> > +
> > +Image: vmlinux
> > +	$(Q)$(MAKE) $(build)=arch/mn10300/boot $@
> > 
> > This could be done as:
> > +Image zImage: vmlinux
> > +	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> 
> Done.
> 
> > And then modify boot/Makefile accordingly
> 
> I don't see why it needs modification.  $(KBUILD_IMAGE) == $(boot)/zImage for
> the zImage target.
For the Image target it is Image without $(boot)/ but that target
was never supported anyway.

> > 1) You can safely remove the copyright of Linus..
> >    Same goes for other places where his copyright are kept but filecontent
> >    is new.
> 
> The copyright assignment on some of these files was made by MEI.  I'm not sure
> I can change them.

It just seemed stupid that someone having copyright on a file
where the person only had contributed the copyright linei (for said file).

	Sam
