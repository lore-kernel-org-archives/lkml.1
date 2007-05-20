Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbXETJwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbXETJwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXETJwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:52:16 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:41379 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbXETJwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:52:15 -0400
Date: Sun, 20 May 2007 02:52:14 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
In-Reply-To: <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
References: <20070519151523.GA26724@uranus.ravnborg.org> 
 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> 
 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> 
 <20070519230940.GJ6291@stusta.de>  <a781481a0705191617v901ac64nfa7040ff302d2da1@ma
 <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Satyam Sharma wrote:
> On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > On Sun, May 20, 2007 at 05:25:24AM +0530, Satyam Sharma wrote:
> > > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > >> On Sun, May 20, 2007 at 05:06:33AM +0530, Satyam Sharma wrote:
> > >> > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > >> There are cases where "default .. if .." is the right idiom, but there
> > >> are also cases where "select" is the right idiom. And for helper code
> > >> like ATARI_KBD_CORE, "select" is the right idiom.
> > >
> > > ATARI_KBD_CORE, unlike MII, is defined only by some archs. And the
> > > correct (most widely used or standard, in any case) idiom for that is
> > > "default .. if ..". Or perhaps you can convert those helper code options in
> > > arch/.../config's over to select too, as an exercise? :-)
> >
> > Perhaps not as an exercise, but actually for real.
> >
> > We had "fixed" such warnings in the past similar to your patch, but that
> > was actually a mistake.
> >
> > And "correct" can easily be the opposite of "most widely used or standard"
> > if you discover that you did it wrong in the past.
>
> In that case the correct approach here too would be to _shift_
> ATARI_KBD_CORE from arch/m68k/Kconfig to drivers/input/Kconfig
> and *then* use "select" from the config options that require it in
> drivers/input/keyboard/Kconfig and drivers/input/mouse/Kconfig
>
> (and repeat for other such cases in arch/...)

You don't need a huge '||' chain, you can always have more than one default
line:

config ATARI_KBD_CORE
	bool
	default y if KEYBOARD_ATARI
	default y if MOUSE_ATARI

Basically a line "config A \n select B" is transformed into "config B \n
default y if A".  It's the same number of lines, they're just in a new place.

Another alternative would be to shift the arch specific drivers to a file
that's arch specific.  e.g. move MOUSE_ATARI from drivers/input/mouse/Kconfig
to arch/m68k/Kconfig.
