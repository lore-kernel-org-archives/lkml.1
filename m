Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXDPThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXDPThm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030909AbXDPThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:37:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030901AbXDPThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:37:41 -0400
Date: Mon, 16 Apr 2007 12:37:43 -0700 (PDT)
Message-Id: <20070416.123743.07452378.davem@davemloft.net>
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070416163712.GA10822@andrew-vasquezs-computer.local>
References: <20070416.010218.130850966.davem@davemloft.net>
	<20070416163712.GA10822@andrew-vasquezs-computer.local>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 09:37:12 -0700

> On Mon, 16 Apr 2007, David Miller wrote:
> 
> > But even if that fails, I think the fallback code should be put back,
> > since it obviously was used by at least one system and it's probable
> > that there are some other applications of using this qla2xxx chip that
> > will have an empty NVRAM too.
> 
> Then they should really get their NVRAM corrected, if in fact their
> NVRAMs are cleared.
> 
> > I can understand the apprehension in using a fixed port_name[] value,
> > since it could conflict with other FC controllers on the mesh, but if
> > that is so important just choose some random value that is a valid FC
> > ID or use some characteristic ID that can be used to compose part of
> > the port WWN in order to give it at least some uniqueness.
> 
> Look, there's a fine balance here that we must strike -- the solution
> that you're proposing implies that there's some 'random' bit-space
> within the IEEE NAA with which one can safely encode without stomping
> on any valid OUI.

The fact is that your driver was significantly more robust
previously, and now it's so less robust that it now fails for
people.

That's totally unacceptable.

Just like the sparc64 systsems, others depending upon this fallback
behavior the qla2xxx driver had are going to break and they are not
going to be able to just go and fix their hardware and re-flash the
NVRAM.

Every user on the planet is going to be 1,000 times more happy with a
big fat warning in their kernel log saying that things might not go
right, but the driver is going to try anyways, rather than a complete
non-attempt to make things work.

You replaced a possible failure with a guarenteed one.

%99.9999999 of people are never going to run into a FC ID collision.
They have an onboard FC controller and a disk or two.  They DON'T
CARE, they want their systems to work and if you don't give them that
you're not being a good driver maintainer.

You BROKE things, therefore you must FIX it.

Now I'm happy to code up the sparc OFW property bits but your attitude
and perspective on this absolutely has to change and the old fallback
code still has to go back in there, possible FC ID collisions or not.
