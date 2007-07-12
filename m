Return-Path: <linux-kernel-owner+w=401wt.eu-S937185AbXGLAkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937185AbXGLAkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXGLAkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:40:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765926AbXGLAkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:40:04 -0400
Date: Wed, 11 Jul 2007 17:39:23 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 05/34] PCI: Use a weak symbol for the empty version of
	pcibios_add_platform_entries()
Message-ID: <20070712003923.GA8132@suse.de>
References: <20070711233037.GB5253@kroah.com> <11841967082916-git-send-email-gregkh@suse.de> <1184196712526-git-send-email-gregkh@suse.de> <11841967172946-git-send-email-gregkh@suse.de> <11841967322884-git-send-email-gregkh@suse.de> <11841967361726-git-send-email-gregkh@suse.de> <20070711234922.GW9704@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711234922.GW9704@parisc-linux.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:49:22PM -0600, Matthew Wilcox wrote:
> On Wed, Jul 11, 2007 at 04:31:19PM -0700, Greg Kroah-Hartman wrote:
> > I'm not sure if this is going to fly, weak symbols work on the compilers I'm
> > using, but whether they work for all of the affected architectures I can't say.
> > I've cc'ed as many arch maintainers/lists as I could find.
> > 
> > But assuming they do, we can use a weak empty definition of
> > pcibios_add_platform_entries() to avoid having an empty definition on every
> > arch.
> 
> This seems like a regression.  We go from having an empty inline
> function that gets optimised away to 0 to having a function call to a
> trivial function.  And on any architecture that *does* define this,
> (unless I misunderstand the GCC manual), we still include the weak
> definition, thus wasting space.

Yeah, but it can be a big pain to add it to every architecture when only
1 or two need it, which is why I see people using the week symbol stuff
more and more, right?  This is just following that trend.

thanks,

greg k-h
