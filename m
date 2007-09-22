Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbXIVPJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbXIVPJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 11:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXIVPJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 11:09:18 -0400
Received: from lixom.net ([66.141.50.11]:41703 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbXIVPJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:09:17 -0400
Date: Sat, 22 Sep 2007 10:11:48 -0500
From: Olof Johansson <olof@lixom.net>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       hch@lst.de
Subject: Re: [PATCH v2] pcmcia: Convert io_req_t to use kio_addr_t
Message-ID: <20070922151148.GA19776@lixom.net>
References: <20070905142742.GA1760@lixom.net> <20070914034854.1658a9cf.akpm@linux-foundation.org> <20070921221516.GA7926@lixom.net> <20070921233936.2aeb2504@the-village.bc.nu> <20070922062551.GE10625@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922062551.GE10625@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 12:25:51AM -0600, Matthew Wilcox wrote:
> On Fri, Sep 21, 2007 at 11:39:36PM +0100, Alan Cox wrote:
> > On Fri, 21 Sep 2007 17:15:16 -0500
> > Olof Johansson <olof@lixom.net> wrote:
> > 
> > > Convert the io_req_t members to kio_addr_t, to allow use on machines with
> > > more than 16 bits worth of IO ports (i.e. secondary busses on ppc64, etc).
> > 
> > What about the formatting and field widths ?
> > 
> > ulong would probably be a lot saner than kio_addr_t and yet more type
> > obfuscation.
> 
> I don't think anyone uses ioports > 32bit.  Certainly i386 takes an int
> port as parameter to {in,out}[bwl] (and it really only uses 16-bits).
> parisc uses 24 bits.  I don't know what the various ppcs do, but pci
> bars can only be 32-bit for ioports.  So my opinion is that ioports
> should be uint, not ulong.

PPC would do just fine with 32-bit as well, which is what I wanted in
the first place. I just went with the local coding standard of pcmcia
and switched to kio_addr_t.

I suppose it's a janitorial todo item but with the maintainer MIA I
don't want to mess around with it too much, since I can't really test
much besides the PPC stuff I have.

As for the formatting/padding widths: Some platforms had ioaddr_t's
that were 32 bit already, so it was already broken on those, and the
only drawback is missing 0-padding. It'd look a bit silly to pad to 16
0:s anyway at the moment, so I think I'd prefer to keep it the way it is.


-Olof
