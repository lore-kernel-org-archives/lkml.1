Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbZIREw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbZIREw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 00:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZIREw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 00:52:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36427 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZIREw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 00:52:57 -0400
Date: Fri, 18 Sep 2009 06:52:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Am?rico Wang <xiyou.wangcong@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Caveh Jalali <ecaveh@gmail.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree
	if it was built using O=
Message-ID: <20090918045259.GA23333@merkur.ravnborg.org>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <200909171345.30988.arnd@arndb.de> <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:49:53AM +0800, Am?rico Wang wrote:
> On Thu, Sep 17, 2009 at 7:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 17 September 2009, Caveh Jalali wrote:
> >
> >> when the platform specific include directories were shuffled around
> >> without updating the
> >> top level Makefile.  however, i think this FAIL is generic, and not
> >> limited to powerpc.
> >> here's a patch to the top level Makefile to teach it about the shuffled files:
> >>
> >>
> >> --- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09
> >> 15:13:59.000000000 -0700
> >> +++ Makefile    2009-09-16 12:23:05.000000000 -0700
> >> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)
> >>                 echo "  in the '$(srctree)' directory.";\
> >>                 /bin/false; \
> >>         fi;
> >> -       $(Q)if [ ! -d include2 ]; then                                  \
> >> -           mkdir -p include2;                                          \
> >> -           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
> >> +       $(Q)if [ ! -d include2 ]; then                                   \
> >> +           mkdir -p include2;                                           \
> >> +           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \
> >>         fi
> >>  endif
> >
> > I think we should no longer have the include2 directory at all with new kernels.
> >
> > LINUXINCLUDE already contains the right path in theory:
> >
> > LINUXINCLUDE    := -Iinclude \
> >                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> >                   -I$(srctree)/arch/$(hdr-arch)/include               \
> >                   -include include/linux/autoconf.h
> 
> Hmm, at least in mmotm, we still have include2...
> 
> Maybe Sam is queueing the patches to remove include2?
I have them queued - yes.
But as they never hit -next they will wait another cycle.

	Sam
