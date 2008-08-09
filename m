Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYHIH1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYHIH1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYHIH1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:27:44 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:34694 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYHIH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:27:43 -0400
Date: Sat, 9 Aug 2008 09:28:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux arch <linux-arch@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080809072822.GB11302@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728200500.GA14284@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 10:05:00PM +0200, Sam Ravnborg wrote:
> The traditional location of the arch specific Makefiles
> has been at:
> 
> 	include/asm-$ARCH
> 
> But as suggested by several people over time and lately
> by Linus in the following post:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
> 
> is is suggested to move the arch specific files under arch/
> and for the header files this is arch/$ARCH/include.

So where are we now?
alpha        Not done - but trivial (I have tested it)
blackfin     Not done - uses symlinks
h8300        Not done - but looks trivial
m32r         Not done - looks trivial
mips         Not done - but I think it is prepared
powerpc      Done
sparc        Done
x86          Not done - assume planned at end of next merge window
arm          Almost done - three plat-* directories needs to be moved
cris         Not done - uses symlinks
ia64         Done
m68k         Not done - may be combined with merging headers for m68knommu
mn10300      Not done - uses symlinks
s390         Done
sparc64      Done
xtensa       Not done - uses symlinks
avr32        Done
frv          Not done - looks trivial
m68knommu    Done
parisc       Not done - but patches are prepared
sh           Done
um           Not done - uses symlinks

So 8 out of 22 so far.

That is pretty good as we only started this at the end of the
merge window.
And of these sh, arm, avr have restructured to avoid symlinks so
it was not that simple.

And we have at six architectures where a simple:
mkdir -p arch/$ARCH/include/asm
git mv include/asm-$ARCH/* arch/$ARCH/include/asm

looks like the only effort needed {alpha, h8300, m32r, mips frv, parisc}.

	Sam
