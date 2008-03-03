Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYCCU3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYCCU3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYCCU2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:28:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbYCCU2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:28:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Date: Mon, 3 Mar 2008 21:27:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20080225090316.GA420@elf.ucw.cz> <20080303154831.22a4eb14@core> <20080303172410.GA13869@elf.ucw.cz>
In-Reply-To: <20080303172410.GA13869@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803032127.30761.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Pavel Machek wrote:
> Hi!
> 
> > > Ok, so linux actually atomicity of long?
>                          ^~-- assumes should be here.
> 
> > No it doesn't. And even if it did you couldn't use long for this because
> > atomic_t also ensures the points operations complete are defined. You
> > might just about get away with volatile long * objects on x86 for simple
> > assignments but for anything else gcc can and will generate code to
> > update values whichever way it feels best - which includes turning
> > 
> > 	long *x = a + b;
> > 
> > into
> > 
> > 	*x = a;
> > 	*x += b;
> 
> Ok, I can understand the gcc side. But do we actually run on an
> architecture where
> 
> long *x;
> 
> *x = 0;
> 
> racing with 
> 
> *x = 0x12345678;
> 
> can produce
> 
> *x == 0x12340000;
> 
> or something like that?

Well something like this could happen, in theory, on a "32-bit" architecture
with a 16-bit bus.  In that case, one can imagine, the first word of the
first write may be sent through the bus immediately followed by the first
word of the second write, followed by the second word of the second
write and by the second word of the first write, in this order.

> I'm told RCU relies on architectures not doing this, and I'd like to get this
> clarified.

Yes, it would be good to know that for sure.

Rafael 
