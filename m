Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbXETLXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbXETLXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbXETLXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:23:48 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:47198 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXETLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:23:47 -0400
Date: Sun, 20 May 2007 04:23:46 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Satyam Sharma <satyam.sharma@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
In-Reply-To: <465029F1.6090301@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.58.0705200416370.1671@shell4.speakeasy.net>
References: <20070519151523.GA26724@uranus.ravnborg.org> 
 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> 
 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> 
 <20070519230940.GJ6291@stusta.de>  <a781481a0705191617v901ac64nfa7040ff302d2da1@ma
 <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com>
 <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net> <465029F1.6090301@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Stefan Richter wrote:
> Trent Piepho wrote:
> > config ATARI_KBD_CORE
> > 	bool
> > 	default y if KEYBOARD_ATARI
> > 	default y if MOUSE_ATARI
> >
> > Basically a line "config A \n select B" is transformed into "config B \n
> > default y if A".  It's the same number of lines, they're just in a new place.
>
> Basically you replace
>
> 	A... depends on B
>
> by
>
> 	B... serves A
>
> The latter variant is a pain to maintain.  Dependencies change over
> time, therefore we should note the dependency always at the dependent
> option, not at the serving option.

The problem is that "B" will not exist on some architectures.  If you put the
dependency with "A", the dependency still exists when "B" is gone.  If the
dependency is with "B", it nicely goes away when "B" is gone.

> Iterating upwards and downwards the dependency graph is the duty of
> "make snafuconfig", not of the maintainers.
>
> Besides, the "serves" form cannot stand in for constructs like
>
> 	A... depends on (B && C) || D

This is for replacing "select" lines, which can't look like that.
