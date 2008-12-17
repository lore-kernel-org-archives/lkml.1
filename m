Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753212AbYLQRdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYLQRdr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYLQRdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:33:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLQRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:33:37 -0500
Date: Wed, 17 Dec 2008 17:33:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, dhowells@redhat.com,
        gerg@uclinux.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217173335.GF28946@ZenIV.linux.org.uk>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org> <20081217170257.GE28946@ZenIV.linux.org.uk> <20081217171800.GA5436@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217171800.GA5436@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 06:18:00PM +0100, Sam Ravnborg wrote:
> I took a different route here and unified the headers for m68k and m68knommu
> under arch/m68k/include/asm
> It was based on a script originally developed by Arnd Bergmann.
> 
> Geert already acked it, and I expect Greg to apply it in the -rc1 timeframe.

Fine by me...

> > * mn10300 is playing with symlinks - the last one to do that for headers,
> >   AFAICS.
> > 
> > I've thrown together a patch series on top of linux-next doing m68k and
> > mn10300.  *WARNING* - it's completely untested, basically about half an
> > hour diversion from sifting through the mailbox for missed VFS patches.
> > And that half and hour did *not* include anything resembling building
> > the resulting tree.  So take that with a trainload of salt.
> Thanks Al.
> I will take a closer look at the mn10300 bits and send them to David
> in due time.

OK.  FWIW, two more uses of ln I've seen while looking at that stuff
are also fishy:
$(obj)/head.o: $(obj)/$(head-y)
        ln -sf $(head-y) $(obj)/head.o
in arch/m68knommu/platform/683{28,60}/Makefile shouldn't be there at all,
AFAICS - normal kbuild machinery will take care of that just fine (with
ld instead of ln, but who the hell cares?)
