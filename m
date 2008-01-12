Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbYALVss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYALVss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 16:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYALVsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 16:48:41 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:57590 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYALVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 16:48:41 -0500
Date: Sun, 13 Jan 2008 00:49:11 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080112214911.GA20102@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112094557.71f5382a@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 09:45:57AM -0800, Arjan van de Ven wrote:
> btw this is my main objection to your patch; it intertwines the conf1
> and mmconfig code even more.

There is nothing wrong with it; please realize that mmconf and conf1 are
just different cpu-side interfaces. Both produce precisely the *same* bus
cycles as far as the lower 256-byte space is concerned.

> When (and I'm saying "when" not "if") systems arrive that only have
> MMCONFIG for some of the devices, we'll have to detangle this again,
> and I'm really not looking forward to that.

MMCONFIG for *some* of the devices? This doesn't sound realistic
from technical point of view.
MMCONFIG-only systems? Sure. I really hope to see these. But it won't
be PC-AT architecture anymore. It has to be something like alpha,
for instance, fully utilizing the 64-bit address space, and we'll have
to have the whole low-level PCI infrastructure completely different
for these future platforms anyway.
Right now, each and every x86 chipset *does* require working
conf1 just in order to set up the mmconf aperture. It's the very
fundamental thing, sort of design philosophy.

Ivan.
