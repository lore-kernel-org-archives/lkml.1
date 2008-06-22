Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYFVWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYFVWEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYFVWEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:04:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39380 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbYFVWEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:04:24 -0400
Date: Mon, 23 Jun 2008 00:05:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Support arch/$ARCH/include in kbuild
Message-ID: <20080622220508.GA8957@uranus.ravnborg.org>
References: <20080621220703.GA12279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621220703.GA12279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 12:07:03AM +0200, Sam Ravnborg wrote:
> Linus hinted that he liked to have all arch specific
> header files moved from include/asm-$ARCH to
> arch/$ARCH/include/asm.
> 
> The following two patches implement the basic support
> for this.
> 
> I have used sparc for my testing and to some degree
> I also used i386.
> 
> For sparc I just had to do a simple:
> 
>     mkdir -p arch/sparc/include/asm
>     mv include/asm-sparc/* arch/sparc/include/asm
> 
> to build sparc with the new directory layout.
> 
> For i386 I had to do a few trivial path fixes in
> arch/x86/Makefile and to fix the include of unistd_32.h
> in one place to fix the build.
> 
> I expect a few additional bits to show up when people
> start to move their header files but this should
> be a good starting point.
> 
> 
> To support arch/$ARCH/include/ was done in two steps.
> 
> First was to teach make headers_* about the new layout.
> And second step was to get the build fixed with the new
> layout.
> 
> Patches are on top of kbuild-next.git and follows.

I redid this and ended up with 5 small patches.

Sam Ravnborg (5):
      kbuild: prepare headers_* for arch/$ARCH/include
      kbuild: include/asm may be a file - fix mrproper for this
      kbuild: support arch/$ARCH/include for tags, cscope
      kbuild: asm symlink support for arch/$ARCH/include
      kbuild: add arch/$ARCH/include to search path

This patchset is tested a more than
the previous one and is now also pushed out
to kbuild-next.git so it will apprear in -next shortly.

There were a few bugs around the symlink handling
and make tags is now also functional.
So I consider this ready for merging.

Any comments are welcome!
Patches will follow as reply to this one, but they
are only sent to kbuild and lkml.

	Sam
