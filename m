Return-Path: <linux-kernel-owner+w=401wt.eu-S935681AbXGLAzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681AbXGLAzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXGLAyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:54:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40527 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbXGLAyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:54:50 -0400
Date: Wed, 11 Jul 2007 18:54:47 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <gregkh@suse.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 05/34] PCI: Use a weak symbol for the empty version of pcibios_add_platform_entries()
Message-ID: <20070712005447.GY9704@parisc-linux.org>
References: <20070711233037.GB5253@kroah.com> <11841967082916-git-send-email-gregkh@suse.de> <1184196712526-git-send-email-gregkh@suse.de> <11841967172946-git-send-email-gregkh@suse.de> <11841967322884-git-send-email-gregkh@suse.de> <11841967361726-git-send-email-gregkh@suse.de> <20070711234922.GW9704@parisc-linux.org> <20070712003923.GA8132@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712003923.GA8132@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 05:39:23PM -0700, Greg KH wrote:
> > This seems like a regression.  We go from having an empty inline
> > function that gets optimised away to 0 to having a function call to a
> > trivial function.  And on any architecture that *does* define this,
> > (unless I misunderstand the GCC manual), we still include the weak
> > definition, thus wasting space.
> 
> Yeah, but it can be a big pain to add it to every architecture when only
> 1 or two need it, which is why I see people using the week symbol stuff
> more and more, right?  This is just following that trend.

But it's already there.  Deleting it now is pointless.

If someone really wants to unify it, better to do:

#ifndef PCIBIOS_PLATFORM_ENTRIES
static inline void pcibios_add_platform_entries(struct pci_dev *dev)
{
}
#endif

in <linux/pci.h> and then PPC can #define PCIBIOS_PLATFORM_ENTRIES
and do its own funky stuff.  This weak symbol stuff has its uses, but
I don't think this is an appropriate use.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
