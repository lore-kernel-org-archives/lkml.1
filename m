Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXLWXU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXLWXU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 18:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXLWXUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 18:20:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:49064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbXLWXUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 18:20:16 -0500
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Martin Mares <mj@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <1198451202.6686.28.camel@pasglop>
References: <476D1D16.5090703@garzik.org>
	 <20071222064719.73fdd9a4@laptopd505.fenrus.org>
	 <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	 <476DB95F.3090801@garzik.org>
	 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	 <476DDFEE.3010009@garzik.org>
	 <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	 <476DE98F.2010009@garzik.org>
	 <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
	 <1198444150.6686.17.camel@pasglop>
	 <mj+md-20071223.211353.32429.nikam@ucw.cz>
	 <1198451202.6686.28.camel@pasglop>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 10:19:07 +1100
Message-Id: <1198451947.6686.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-24 at 10:06 +1100, Benjamin Herrenschmidt wrote:
> On Sun, 2007-12-23 at 22:15 +0100, Martin Mares wrote:
> > Hello!
> > 
> > >  - During that probe, you set a flag if any device has capabilities that
> > > extend beyond 0xff.
> > 
> > Can this work?  The extended capabilities are not linked to the normal
> > ones in any way.
> 
> Yeah, well, you set a flag if you have extended capabilities. I don't
> have my spec at hand (or the code) but can't we know if there are any
> based on some non-ext field ?

Allright, I d/l the spec and you are right... 

Yet another massive Intel f*ckup in the definition of PCI... Argh.

So that means you can't automatically detect that there's potentially
stuff in the extended caps. You still can do the initial probe solely
with type1, that would work around the problem with MMCONFIG overlapping
sized BARs (ah, BAR sizing, yet another case where somebody at Intel
should rather have broken an arm that day).

I still don't believe much in the idea of drivers enabling MMCONFIG
though.
 
Ben.,
 

