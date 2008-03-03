Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbYCCRgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbYCCRgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbYCCRXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:23:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55069 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761708AbYCCRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:23:40 -0500
Date: Mon, 3 Mar 2008 18:24:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
	is required
Message-ID: <20080303172410.GA13869@elf.ucw.cz>
References: <20080225090316.GA420@elf.ucw.cz> <Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org> <20080303120842.GA28369@elf.ucw.cz> <20080303154831.22a4eb14@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303154831.22a4eb14@core>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, so linux actually atomicity of long?
                         ^~-- assumes should be here.

> No it doesn't. And even if it did you couldn't use long for this because
> atomic_t also ensures the points operations complete are defined. You
> might just about get away with volatile long * objects on x86 for simple
> assignments but for anything else gcc can and will generate code to
> update values whichever way it feels best - which includes turning
> 
> 	long *x = a + b;
> 
> into
> 
> 	*x = a;
> 	*x += b;

Ok, I can understand the gcc side. But do we actually run on an
architecture where

long *x;

*x = 0;

racing with 

*x = 0x12345678;

can produce

*x == 0x12340000;

or something like that? I'm told RCU relies on architectures not doing
this, and I'd like to get this clarified.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
