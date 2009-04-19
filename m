Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZDSG0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZDSG0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZDSG0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:26:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34295 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZDSG0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:26:37 -0400
Date: Sun, 19 Apr 2009 08:28:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: kbuild - introduce support for subdir-ccflags-y
Message-ID: <20090419062841.GA17801@uranus.ravnborg.org>
References: <20090418125159.GA23008@uranus.ravnborg.org> <20090418125839.GA3668@flint.arm.linux.org.uk> <20090418150750.GA24059@elte.hu> <20090418180953.GE7148@flint.arm.linux.org.uk> <f73f7ab80904182017n7f27f49ck48ba200deb99388a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f73f7ab80904182017n7f27f49ck48ba200deb99388a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 11:17:44PM -0400, Kyle Moffett wrote:
> On Sat, Apr 18, 2009 at 2:09 PM, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > On Sat, Apr 18, 2009 at 05:07:50PM +0200, Ingo Molnar wrote:
> >> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >> > On Sat, Apr 18, 2009 at 02:51:59PM +0200, Sam Ravnborg wrote:
> >> > > The typical use cases are an architecture or a subsystem that
> >> > > decide to cover all files with -Werror.
> >> > > Today alpha, mips and sparc uses -Werror in almost all their
> >> > > Makefile - with subdir-ccflag-y it is now simpler to do so
> >> > > as only the top-level directories needs to be covered.
> >> >
> >> > Hmm, this won't make sense for ARM.  We have things like #warning
> >> > and deprecated functions in machine specific headers, and adding
> >> > -Werror to the whole of arch/arm/ will result in these causing
> >> > builds to fail.
> >>
> >> This is optional - if you dont want it, you dont set it.
> >
> > Please read _all_ of my mail, particularly the bit where it talks about
> > it being useful for a certain subset.
> 
> It's my impression that on x86 it's a config option whether or not to
> build with -Werror.  You could do the exact same thing with an
> internal inverted-logic CONFIG_ARM_ALLOW_WARNINGS option and make all
> the boards triggering warnings "select ARM_ALLOW_WARNINGS".  Then have
> a user-visible config option "ARM_USER_ALLOW_WARNINGS" which also
> selects the internal option.  That adds some additional kconfig-level
> documentation on which subarch combos need some love.

Correct - but Russell's original comment was that the subdir-* feature
was of no use for arm. And this is correct with the current way
the individual directories are specified.

If you compare arch/x86/kernel/ and arch/arm/kernel/ you will see
that x86 has 3 subdirectories where arm has none.

Another measure:
Arm has 12 Makefiles outside mach* and plat* where x86 has 24 Makefiles.

Ao unless Russell decide to take the patch that refactor all the core-*
stuff out in a Kbuild file arm has no use of subdir-ccflags-y and
can use the already existing ccflags-y if they decide to cover
most of arm with -Werror.

	Sam
