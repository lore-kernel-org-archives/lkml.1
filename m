Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbXETJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbXETJnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXETJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:43:42 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3979 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXETJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:43:41 -0400
Date: Sun, 20 May 2007 10:43:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520094332.GB9645@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <20070519230537.GI6291@stusta.de> <20070519162239.1bcb03d6.akpm@linux-foundation.org> <20070520000235.GP6291@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520000235.GP6291@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 02:02:35AM +0200, Adrian Bunk wrote:
> On Sat, May 19, 2007 at 04:22:39PM -0700, Andrew Morton wrote:
> > On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > Look for example at the last one in drivers/input/mouse/Kconfig:
> > > 
> > > config MOUSE_ATARI
> > >         tristate "Atari mouse"
> > >         depends on ATARI
> > >         select ATARI_KBD_CORE
> > > 
> > > This is perfectly correct (the select'ed symbol is only unavailable when 
> > > the dependency can't be fulfilled), and all things to "fix" the warning 
> > > will make it worse.
> > 
> > If ATARI is unset then we shouldn't be generating the "'select' used by
> > config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
> > warnings, should we?
> 
> Exactly.

If we do that we need to try a million and one Kconfig option combinations
to find undefined symbols.  Not practical.

(And no, allyconfig really doesn't hack it on non-x86 platforms, no matter
how much people whinge that it should do.  It's a pipedream to make it so.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
