Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYA3DqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYA3DqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYA3Dp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:45:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33212 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYA3Dp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:45:58 -0500
Date: Tue, 29 Jan 2008 20:45:55 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080130034555.GA17537@parisc-linux.org>
References: <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128190505.5f5b1ccc@laptopd505.fenrus.org> <20080129031804.GF20198@parisc-linux.org> <20080129131955.GC10761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129131955.GC10761@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 05:19:55AM -0800, Greg KH wrote:
> On Mon, Jan 28, 2008 at 08:18:04PM -0700, Matthew Wilcox wrote:
> > I'm more optimistic because we've so severely restricted the use of
> > mmconf after these patches that it's unlikely to cause problems.  I also
> > hear Vista is now using mmconf, so fewer implementations are going to
> > be buggy at this point.
> 
> Hahahaha, oh, that's a good one...

Thanks Greg.  What happened to "Can't we all try to get along"?

> But what about the thousands of implementations out there that are
> buggy?
> 
> I'm with Arjan here, I'm very skeptical.

Maybe I'm insufficiently imaginative.  Can you come up with a plausible
way in which the two patches I posted will succumb to bugs?  After those
patches we only use mmconf if:

 1. conf1 has failed to work
OR
 2. user has compiled their own kernel without support for conf1
OR
 3. kernel probes config space 0x100 to see if it can access extended
    config space (requires the device to be PCIe or PCI-X2)
OR
 4. root attempts to lspci -xxxx or lspci -v
OR
 5. device driver tries to access extended config space

With Arjan's patch, I believe only case 3 changes.  In cases 4 and 5,
either lspci or the device driver will jump through the hoop to enable
access to extended config space.

> Matthew, with Arjan's patch, is anything that currently works now
> broken?  Why do you feel it is somehow "wrong"?

lspci is broken.  It used to be able to access extended config space, and
now can't unless it is patched to know about the sysfs flag to enable it.

If you're determined to implement something to disable extended config
space by default, it can be done in a much better way than Arjan's patch
-- less code (both source and object).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
