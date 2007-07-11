Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbXGLAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbXGLAHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935874AbXGKXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:49:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52522 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936050AbXGKXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:49:24 -0400
Date: Wed, 11 Jul 2007 17:49:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 05/34] PCI: Use a weak symbol for the empty version of pcibios_add_platform_entries()
Message-ID: <20070711234922.GW9704@parisc-linux.org>
References: <20070711233037.GB5253@kroah.com> <11841967082916-git-send-email-gregkh@suse.de> <1184196712526-git-send-email-gregkh@suse.de> <11841967172946-git-send-email-gregkh@suse.de> <11841967322884-git-send-email-gregkh@suse.de> <11841967361726-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11841967361726-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 04:31:19PM -0700, Greg Kroah-Hartman wrote:
> I'm not sure if this is going to fly, weak symbols work on the compilers I'm
> using, but whether they work for all of the affected architectures I can't say.
> I've cc'ed as many arch maintainers/lists as I could find.
> 
> But assuming they do, we can use a weak empty definition of
> pcibios_add_platform_entries() to avoid having an empty definition on every
> arch.

This seems like a regression.  We go from having an empty inline
function that gets optimised away to 0 to having a function call to a
trivial function.  And on any architecture that *does* define this,
(unless I misunderstand the GCC manual), we still include the weak
definition, thus wasting space.

I don't think this is a good use of weak functions.  It's perfectly
normal to have header files filled with empty functions.  They're even
good documentation for what an architecture might want to fill in,
rather than invent their own mechanism for doing something.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
