Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbYDOXif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbYDOXif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYDOXi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:38:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYDOXiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=j5xMdM5RHVcodH6KrEDsMgm2BaM7k1PuJduM3pmHoLDaVB3E+j3YAiKTaGvUBesUnysJ6q7y6fVFZC5CIsSNPdCpHj8R5xHbsN5UUHmE5QfW5XjEzX+Jc3styuViJ09JcHNdKwUFWyQVEO6LhKl/YS7eun0Nm/GYxWxznTWYSYY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [2.6 patch] PCMCIA mustn't select HAVE_IDE
Date: Wed, 16 Apr 2008 01:26:10 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080415221002.GL1677@cs181133002.pp.htv.fi> <20080415223928.GH5676@flint.arm.linux.org.uk>
In-Reply-To: <20080415223928.GH5676@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804160126.11116.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Russell King wrote:
> On Wed, Apr 16, 2008 at 01:10:02AM +0300, Adrian Bunk wrote:
> > On Tue, Apr 15, 2008 at 11:03:45PM +0100, Russell King wrote:
> > > On Wed, Apr 16, 2008 at 12:52:23AM +0300, Adrian Bunk wrote:
> > >...
> > > So this is a only impacting ARM wrt. PCMCIA, and given that ARM supplies
> > > an asm/ide.h, it's _entirely_ reasonable that if a platform has PCMCIA
> > > then it supports IDE.
> > > 
> > > > We could simply always select HAVE_IDE on arm instead of manually 
> > > > setting which platforms could possibly get IDE support (e.g. are there
> > > > any boards with PCI slots for which HAVE_IDE is currently not 
> > > > selected?).
> > > 
> > > You could, if there was a demand for it.  As no one has added that,
> > > I conclude that its less common for people to stick an IDE controller
> > > into a PCI backplane.
> > 
> > People can always enable code for stuff they don't use.
> > 
> > But instead of having 14 ARM platforms plus PCMCIA (which is offered 
> > unconditionally on all ARM platforms...) select HAVE_IDE it's simpler
> > to select it once for all ARM platforms.

Please send me a patch doing this, it should be safe for current IDE tree.

> That would seem logical, but Bart objects to that idea.

I don't remember the background but I think it was needed because of badly
perplexed ide_init_hwif_ports() and friends in <asm/ide.h> vs <linux/ide.h>
(almost all this stuff is gone in IDE tree for 2.6.26)...

Ok, I found the patch:

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=4b3b8ee5db374b76608537e061f2efd90e21179d

[ tglx's history tree since it is from May 2004. ]

> However, consider that we're gradually transitioning over to being
> exclusively libata only.
> 
> > > In fact, there are only three classes of ARM platforms which have PCI
> > > selected but not HAVE_IDE - IOP13xx, IXP2000, and Orion.  I suspect
> > > the only reason they don't select it because they now use the ATA code
> > > rather than the old IDE code - that's certainly true of Orion.
> > 
> > The libata options are offered unconditionally on all platforms...
> 
> It wasn't *my* choice to restrict IDE on ARM.  See Bart for that
> decision.

It could be that I did the poor job of explaining things back then
but I also didn't like the fact that I needed to restrict the IDE
choice on ARM - the change in question was _necessary_ to start
converting IDE drivers to become real, independent, modular host
drivers and as a preparation for adding proper warm-plug support.

Thanks,
Bart
