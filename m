Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYCZIVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYCZIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCZIVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:21:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:55948 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCZIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:21:11 -0400
Subject: Re: [PATCH] Work around breakage introduced in pata_sil680 by
	switching it to MMIO
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jeff Garzik <jeff@garzik.org>, Tim Ellis <tim@ngndg.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080325233629.1fcc2eaa@core>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	 <1202850129.7410.22.camel@pasglop>
	 <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	 <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop>
	 <DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com>
	 <47C347C3.40404@garzik.org> <1203987502.15052.71.camel@pasglop>
	 <Pine.LNX.4.64.0803260023030.1539@axis700.grange>
	 <20080325233629.1fcc2eaa@core>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 19:20:22 +1100
Message-Id: <1206519623.10573.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 23:36 +0000, Alan Cox wrote:
> On Wed, 26 Mar 2008 00:31:19 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > pata_sil680 is broken on Linkstation amd Kurobox HG machines since 2.6.24. 
> > Work around the breakage until a real fix is found.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Just disable the mmio patch on all systems - we know it doesn't work, we
> know what work needs to be done, it should remain off for everyone until
> that work is done. It should never have been merged in the first place
> and I think my statement to that effect has been proven nicely.

Agreed. We did some patches to work on the possible write posting
issues, and they didn't fix the problem, though they still should go in
ultimately (after more testing, I need to dig them back out of my pile).

So I think the MMIO is on standby now until we really corner what's
going on. I hope to be able to work a bit on Guennadi's setup one of
these days though I can't promise, I may instead get that SiL controller
out of a cell blade and stick it in every HW I have around see if I can
reproduce the problem. I think I have a couple different revisions even.

We need to keep it enabled for the QS20 cell blades as it's the only way
those will boot (and they happen to apparently not suffer from any
adverse effect, we've tortured them pretty deeply, could be luck due to
how the bridge works on them, or due to other workarounds we do for
horrid breakage in the PCI host bridge that end up making everything
else work too) but everybody else can stick with PIO.

Jeff, can you ask Linus to pull my patch (the one Alan just acked) that
does that in .25 ?

Cheers,
Ben.



