Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbZE1Fs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbZE1Fs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZE1Fsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:48:52 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50133 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbZE1Fsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:48:51 -0400
Date: Thu, 28 May 2009 15:47:14 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: David Miller <davem@davemloft.net>
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528054714.GM1464@yookeroo.seuss>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	linux@arm.linux.org.uk, jonsmirl@gmail.com,
	devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
	timur@freescale.com, scottwood@freescale.com,
	yuan-bo.ye@motorola.com, linux-arm-kernel@lists.arm.linux.org.uk
References: <20090528025258.GB1464@yookeroo.seuss> <20090527.212730.183576278.davem@davemloft.net> <20090528044732.GK1464@yookeroo.seuss> <20090527.223147.94364683.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.223147.94364683.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:31:47PM -0700, David Miller wrote:
> From: David Gibson <david@gibson.dropbear.id.au>
> Date: Thu, 28 May 2009 14:47:32 +1000
> 
> > The conceptual problem becomes apparent when you consider things like
> > i2c.  The devtree is the obvious source to discover what i2c device
> > are present, but they need to be instantiated as i2c devices on the
> > i2c bus, not of platform devices.
> 
> Sure, but there is no reason there can't be an of_platform driver
> for those i2c devices.  And such instantiated devices get propagated
> either instantly to the parent, or later when the parent controller
> probes.

Right, but the point is the bus info is trying to do two things here -
one is to supply stuff that's actually common to the bus interface,
the other is the probing logic.  That's usually connected to the bus
interface, but in the case of non-probeable basses on a system with a
devtree, that's no longer the case.  As soon as the bus has some
common logic that's really related to the bus interface regardless of
platform, then you start losing to use of_platform instead of a
specific bus structure because you have to duplicate that -
essentially having both OF and non-OF variants of however many busses
we need.

I think its saner instead to have the device model stuff only
represent stuff that's actually related to the bus interface, and
separately instantiate things into those busses from an OF tree
traversal.  I think this can be made as convenient as the current
setup for OF systems, though obviously I'll have to get around to
actually implementing it to be sure.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
