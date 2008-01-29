Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYA2PbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYA2PbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYA2PbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:31:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYA2PbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:31:05 -0500
Date: Tue, 29 Jan 2008 07:29:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tcamuso@redhat.com
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080129072951.5c8af9a0@laptopd505.fenrus.org>
In-Reply-To: <479F4321.6030106@redhat.com>
References: <20080114225225.GQ18741@parisc-linux.org>
	<20080114230448.GL9847@does.not.exist>
	<478CD8A5.5090608@myri.com>
	<20080115174643.GB28238@kroah.com>
	<20080115175641.GE18741@parisc-linux.org>
	<20080119165809.GB11553@colo.lackof.org>
	<479E1FA6.1030708@redhat.com>
	<20080128204431.GA15227@kroah.com>
	<20080128190505.5f5b1ccc@laptopd505.fenrus.org>
	<20080129031804.GF20198@parisc-linux.org>
	<20080129131955.GC10761@kroah.com>
	<479F34E6.40806@redhat.com>
	<20080129064724.0f7e91e5@laptopd505.fenrus.org>
	<479F4321.6030106@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 10:15:45 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> Arjan van de Ven wrote:
> > On Tue, 29 Jan 2008 09:15:02 -0500
> > Tony Camuso <tcamuso@redhat.com> wrote:
> > 
> >> Greg,
> >>
> >> The problem with Arjan's patch, if I understand it correctly, is
> >> that it requires drivers to make a call to access extended PCI
> >> config space.
> >>
> >> And, IIRC, Arjan's patch encumbers drivers for all arch's, even
> >> those that have no MMCONFIG problems.
> >>
> >> The patches proposed by Loic, Ivan, Matthew, and myself, all
> >> address the problem in an x86-specific manner that is transparent
> >> to the drivers.
> > 
> > this is not quite correct; the patches from Loic, Ivan, Matthew and
> > you are for a different problem statement.
> > 
> > Your patch problem statement is "need to fix mmconfig", my patch
> > problem statement is "need to not make users who don't need it
> > suffer". These are orthogonal problems.
> > 
> > 
> 
> Yes, but your patch also makes users who need extended PCI config
> space suffer.
> 
> Right now, that isn't a lot of people in x86 land, but your patch
> encumbers drivers for non-x86 archs with an additional call to access
> space that they've never had a problem with.

lets say s/x86/x86, IA64 and architectures that use intel, amd or via chipsets/



> As more PCI express drivers start to take advantage of AER and other
> advanced express capabilities, the extra call to address a condition
> specific to legacy x86 hardware is, IMNSHO, a kludge.

in addition to pci_enable(), pci_enable_msi(), pci_enable_busmaster() they already need to do
to enable various features?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
