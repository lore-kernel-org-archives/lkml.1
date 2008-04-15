Return-Path: <linux-kernel-owner+w=401wt.eu-S932876AbYDOWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbYDOWkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYDOWkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:40:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40572 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbYDOWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:40:00 -0400
Date: Tue, 15 Apr 2008 23:39:28 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Message-ID: <20080415223928.GH5676@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080414175344.GA15028@uranus.ravnborg.org> <200804152215.34904.bzolnier@gmail.com> <20080415212326.GF1677@cs181133002.pp.htv.fi> <20080415212822.GE5676@flint.arm.linux.org.uk> <20080415214203.GF5676@flint.arm.linux.org.uk> <20080415215223.GK1677@cs181133002.pp.htv.fi> <20080415220344.GG5676@flint.arm.linux.org.uk> <20080415221002.GL1677@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415221002.GL1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 01:10:02AM +0300, Adrian Bunk wrote:
> On Tue, Apr 15, 2008 at 11:03:45PM +0100, Russell King wrote:
> > On Wed, Apr 16, 2008 at 12:52:23AM +0300, Adrian Bunk wrote:
> >...
> > So this is a only impacting ARM wrt. PCMCIA, and given that ARM supplies
> > an asm/ide.h, it's _entirely_ reasonable that if a platform has PCMCIA
> > then it supports IDE.
> > 
> > > We could simply always select HAVE_IDE on arm instead of manually 
> > > setting which platforms could possibly get IDE support (e.g. are there
> > > any boards with PCI slots for which HAVE_IDE is currently not 
> > > selected?).
> > 
> > You could, if there was a demand for it.  As no one has added that,
> > I conclude that its less common for people to stick an IDE controller
> > into a PCI backplane.
> 
> People can always enable code for stuff they don't use.
> 
> But instead of having 14 ARM platforms plus PCMCIA (which is offered 
> unconditionally on all ARM platforms...) select HAVE_IDE it's simpler
> to select it once for all ARM platforms.

That would seem logical, but Bart objects to that idea.

However, consider that we're gradually transitioning over to being
exclusively libata only.

> > In fact, there are only three classes of ARM platforms which have PCI
> > selected but not HAVE_IDE - IOP13xx, IXP2000, and Orion.  I suspect
> > the only reason they don't select it because they now use the ATA code
> > rather than the old IDE code - that's certainly true of Orion.
> 
> The libata options are offered unconditionally on all platforms...

It wasn't *my* choice to restrict IDE on ARM.  See Bart for that
decision.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
