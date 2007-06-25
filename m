Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXFYCds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXFYCds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 22:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXFYCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 22:33:41 -0400
Received: from lixom.net ([66.141.50.11]:48152 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXFYCdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 22:33:41 -0400
Date: Sun, 24 Jun 2007 21:42:52 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, akpm@osdl.org, paulus@samba.org
Subject: Re: [PATCH] pcmcia: ppc64 needs 32-bit ioaddr_t
Message-ID: <20070625024252.GA31653@lixom.net>
References: <20070625005439.GA31289@lixom.net> <200706250335.56739.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706250335.56739.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 03:35:56AM +0200, Arnd Bergmann wrote:
> On Monday 25 June 2007, Olof Johansson wrote:
> > ppc64 really needs ioaddr_t to be 32-bit, since I/O addresses really are
> > MMIO addresses, and remapped at an offset that's well above 16 bits in
> > some cases.
> > 
> > While the type is exported to userspace, there hasn't been any platforms
> > with PCMCIA on 64-bit powerpc until now, so changing it won't regress
> > any existing users.
> 
> I just realized that this argument is bogus, because the user space tools
> are probably, or at least potentially, built as 32 bit binaries, which
> means that any interface using these _will_ break.

Fortunately, on the userspace ABI, it should just be the cardmgr
ioctls that are affected. In this case there are no current 64-bit PPC
platforms with PCMCIA, so there are no existing users to regress. New
users (with 32-bit userspace) shouldn't be using the cardmgr tools.

So yes, someone who takes an old 32-bit userspace with cardmgr, moves
it to a new 64-bit platform and expects the old 32-bit tools to work
will find that they don't. Not that they would have otherwise either.

> However, I could not find any actual user space interfaces in 2.6.22-rc
> that are built around ioaddr_t. What are they, or have the been removed
> by now?

Last time I posted this I got the answer from Christoph that it's cardmgr
and the ioctl interface it uses, and there's still users out there that
have been neglecting the error messages, etc.

Unfortunately, ioaddr_t is used both in the ioctl interface as well as
to pass around some of the same structures within the kernel. So I could
either do major overhaul of the PCMCIA stack, or change this type for
ppc64. I went for the latter given that MIPS and ARM obviously already
got away with doing it.


-Olof
