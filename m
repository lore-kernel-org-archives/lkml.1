Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbXESXdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbXESXdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbXESXc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:32:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20017 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbXESXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p07ZefLiTjE8CBud5UYE5wotwk5dBcqqkepn2aSJrOwekZAt87Ln4FOvmQBQRXR9ybuerdpkKOsrk6+dCRrmuHXxcdpIpBPipgXhb8ZyK2KTrh9ynIv5jsCkUXhpvoZzRJ5s5aVL+cpbk+lWM1ongyhXR3V3Qzfo/XXql5VUf4M=
Message-ID: <a781481a0705191632l5d57a044r46317321ac463f88@mail.gmail.com>
Date: Sun, 20 May 2007 05:02:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070519232900.GM6291@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <20070519230537.GI6291@stusta.de>
	 <a781481a0705191617g7709f323p15cbc28fa7603e1c@mail.gmail.com>
	 <a781481a0705191621w28e97a6bv32931ff0d46b08f5@mail.gmail.com>
	 <20070519232900.GM6291@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, May 20, 2007 at 04:51:44AM +0530, Satyam Sharma wrote:
> > On 5/20/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> >> On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> >> > On Sat, May 19, 2007 at 11:09:44AM -0700, Andrew Morton wrote:
> >> > > On Sat, 19 May 2007 17:15:23 +0200 Sam Ravnborg <sam@ravnborg.org>
> >> wrote:
> >> > >
> >> > > > We see a lot of these lately:
> >> > > >   GEN     /home/bor/build/linux-2.6.22/Makefile
> >> > > > scripts/kconfig/conf -s arch/i386/Kconfig
> >> > > > drivers/macintosh/Kconfig:116:warning: 'select' used by config
> >> symbol 'PMAC_APM_EMU' refers to undefined symbol
> >> 'SYS_SUPPORTS_APM_EMULATION'
> >> > > > drivers/net/Kconfig:2283:warning: 'select' used by config symbol
> >> 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> >> > > > drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
> >> symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> >> > > > drivers/input/mouse/Kconfig:182:warning: 'select' used by config
> >> symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> >> > > >
> >> > > >
> >> > > > Do this warning really add any value or should we just ignore them
> >> like this?
> >> > > >
> >> > >
> >> > > They always indicate Kconfig bugs, don't they?  If so, we should keep
> >> the
> >> > > warning.
> >> > >...
> >> >
> >> > No, they aren't always.
> >> >
> >> > Look for example at the last one in drivers/input/mouse/Kconfig:
> >> >
> >> > config MOUSE_ATARI
> >> >         tristate "Atari mouse"
> >> >         depends on ATARI
> >> >         select ATARI_KBD_CORE
> >> >
> >> > This is perfectly correct (the select'ed symbol is only unavailable when
> >> > the dependency can't be fulfilled), and all things to "fix" the warning
> >> > will make it worse.
> >>
> >> Not sure what you mean here. The select'ed symbol here is unavailable
> >> because not all arch's define it. However, the symbol that selects it is
> >> in drivers/input/... and hence run for all arch's. That's the simple issue
> >> here that is resolved by this fix.
> >
> > And by the way, this is precisely the case for _all_ the select issues in
> > this
> > patch (the four that were raised by Sam) -- i.e. only one arch defining a
> > config option that is selected by stuff in drivers/... which is common for
> > all archs, and hence the warnings on other archs.
> >
> > I don't see any problem at all that is introduced / "made worse" by the
> > patch, it just rectifies the problem to get rid of the warnings.
>
> There's no doubt that it gets rid of the warnings.

Ah, ok, so you're saying that these warnings would not lead to build
failures in any case, so we might as well not print the warnings at all?
I can't confirm that, have never tried to build these drivers here (don't
have m68k / powerpc boxen), so perhaps you're right.

> But the warnings don't point to problems and the "fixes" for the
> warnings make the Kconfig's worse.
>
> If fixing warnings makes something not better but worse, it's always
> worth a thought whether to disable the warning.

There is nothing that is "made worse" by the "select -> default .. if .."
kind of conversion here.

In any case, the problem with Sam's patch is that it gets rid of
warnings for all cases where someone is trying to "select" a config
option that does not exist at all (and perhaps some of those cases
_could_ lead to build breakages).
