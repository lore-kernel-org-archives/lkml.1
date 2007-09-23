Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbXIWHWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbXIWHWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 03:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXIWHWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 03:22:12 -0400
Received: from barikada.upol.cz ([158.194.242.200]:43576 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbXIWHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 03:22:11 -0400
Date: Sun, 23 Sep 2007 09:37:48 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
Message-ID: <20070923073748.GR24301@flower.upol.cz>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr> <E1IZ788-0003LZ-Qs@flower> <20070922204002.GA31873@uranus.ravnborg.org> <20070922222311.GQ24301@flower.upol.cz> <20070923060335.GA22208@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923060335.GA22208@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 08:03:35AM +0200, Sam Ravnborg wrote:
> > > Please Oleg.
> > > You know very well that most people will not have their kernel src RO.
> > 
> > Sure, if it will be not comfortable.
> > 
> > But if kbuild deals with this transparently, it must be OK. Brokenness
> > due to binutils, kbuild, root user bugs won't garbage source. Only thing
> > to ask from experienced users *and* kernel developers, is
> > `useradd kbuild`, everything else will not bother anybody.
> Better would be to fix the bugs where we today clobber the sources.
> Care to point out the exact cases you see.

It is not about particular case, it is about whole environment.

* interactive:
    shell (profile setup).--> source editing / patching
                          `-> building parts / doing tests

    where profile is one particular source tree with particular
    config/development goals. On multiple terminals (sessions), one
    may just type in favorite shell `wana profile-xx` and environment
    is set up there. I.e.

    + where ever you are, it's easy to go to current obj or src tree,
    + quilt knows its setup
    + kbuild does also
    + tracking files, sent to editor (e.g. emacsclient / emacsserver)
      o easily composing file / change sets to be operated by quilt
      o kbuild knows exactly what to check and possibly to rebuild
    + all actions are written to history, that can be imported into any session
      o saving sessions
      o restore sessions: checking profile consistency / updating
    + less ugly (e.g. just stupid bash command line) user interface
      o even ordinary command line can be improved much-much more in
        terms of efficiency and comfort
      o more nice-looking information of what is happening and how is
        happening

* automatic:
    running setup of selected profiles:
    o patch/update sources
    o configure and (cross) build multiple source trees with multiple output
      trees each.
    o run time testing: emulators, hardware.

Many ideas, collected in kbuild-2.5-history.tar.bz2 back in 2000, are
still interesting and useful.

More i do development, more i realize, that i spend too much time to
do trivial and repeating things. And this time will not go less, if
something like that will be by hand.

I'd really like to see a work flow of best development staff, because
behind patches i can not see anything. And frankly, i doubt there's
anything significant there. The only sharing of tools i can see is
patch scripts (now quilt), diff-tools, linux/scripts. Still just tools.

There's no environment, where people would know particular configs for
editors, mailers, 2-3 steps easy to get right help messages, i.e
*environment*. UI tricks, like common, most useful, sh aliases for using
tools, different color schemas: for error/log output, editing C or asm
(with linux specific annotations, rules), tools like checkpatch, but not
checkpatch -- helper for developers to get changes checked and ready to
create actual patch, etc. etc. etc....

For example, i'd really like to have, candy C + diff color fontlocking
(emacs' brain damaged lexicon) for easy patch reviewing. I did some
trivial enhancements more than 3 years ago, like highlighting of actions
that change variable's value, thus, i don't do many stupid things in C any
more. I'd like to have candy fontlocking for sed and shell and
sed-in-shell syntax, etc. etc.

And all this is needed just for stupid terminal emulator. So, what
people are doing all this time? Noo, X? There's no X, period.
____
