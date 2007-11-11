Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbXKKLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbXKKLxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 06:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXKKLxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 06:53:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41862 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbXKKLxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 06:53:15 -0500
Date: Sun, 11 Nov 2007 12:54:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/5] introduce K64BIT=y and backward compatibility ARCH={i386,x86_64} for x86
Message-ID: <20071111115453.GA8112@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <20071111050945.GB21669@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111050945.GB21669@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 06:09:45AM +0100, Adrian Bunk wrote:
> On Sat, Nov 10, 2007 at 09:40:38PM +0100, Sam Ravnborg wrote:
> 
> > As discussed in another thread the right thing is to add a generic solution
> > to select between 32 and 64 bit - useable for powerpc, s390, ppc et al.
> >...
> 
> I seriously question this would be "the right thing".
> 
> 32/64bit isn't that special that this and only this option would require
> special casing, and the KISS principle of having only one way to specify 
> something like this has it's advantages.

"The right thing" in the correct context.
It was discussed to keep ARCH={i386,x86_64} and the point I have
is that if we are going to extend ARCH=... to be useable to
specify kernel bit size then it should be done in a generic way
and not like it was done before on x86.

I do not consider the discussion about keeping/dropping
ARCH={i386,x86_64} as concluded.

And if we decide on keeping ARCH={i386,x86_64} then I have
questioned the semantics. Clear opinions are missing..

ARCH= semantic

Impact                   before             now
================================================
32/64 bit                 yes               yes
bzImage location          yes               no
different Kconfig files   yes               no
decide defconfig          yes               yes
asm symlink               no                no
build option              yes               no [1]

[did I miss anything? I think I did]

[1] ARCH=... select 32/64-bit during configuration.
    There is no difference between ARCH={x86,i386,x86_64}
    when building the kernel because the 32/64 bit
    choice is done at configuration time.

The table above reflect the [now] semantics with the
patches that is present at lkml.

And the patch needed to implment the above
semantic (after the preparational stuff which
is generic) are:

$ git diff --stat HEAD~1..HEAD
 Makefile                 |   18 ++++++++++++++----
 arch/x86/Makefile        |    8 ++++++--
 scripts/kconfig/Makefile |    2 +-
 3 files changed, 21 insertions(+), 7 deletions(-)


The scripts/kconfig/Makefile change is a bugfix that maybe
should be included in another patch. It is not x86 specific.

So 19 additional lines and 5 deleted lines to introduce the
ARCH= semantics above.

	Sam

