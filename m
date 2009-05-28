Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbZE1Erq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbZE1Erq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 00:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZE1Eri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 00:47:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39802 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZE1Erh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 00:47:37 -0400
Date: Thu, 28 May 2009 14:47:32 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: David Miller <davem@davemloft.net>
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, devicetree-discuss@ozlabs.org,
       linux-kernel@vger.kernel.org, timur@freescale.com,
       scottwood@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528044732.GK1464@yookeroo.seuss>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	linux@arm.linux.org.uk, jonsmirl@gmail.com,
	devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
	timur@freescale.com, scottwood@freescale.com,
	yuan-bo.ye@motorola.com, linux-arm-kernel@lists.arm.linux.org.uk
References: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090528025258.GB1464@yookeroo.seuss> <20090527.212730.183576278.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.212730.183576278.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:27:30PM -0700, David Miller wrote:
> From: David Gibson <david@gibson.dropbear.id.au>
> Date: Thu, 28 May 2009 12:52:58 +1000
> 
> > The of_platform bus model is conceptually completely broken, but in
> > practice only slightly broken for all common cases.
> 
> The fact that every single SBUS and EBUS driver for sparc is now an
> of_platform driver, and the fact that as a further result joint
> SBUS/PCI drivers are now almost completely unified, speaks volumes to
> the fact that it is not broken.

Only because the set of busses that need to be probed using devtree
information has a very large overlap with the set of busses that are
specific to OF aware platforms.

The conceptual problem becomes apparent when you consider things like
i2c.  The devtree is the obvious source to discover what i2c device
are present, but they need to be instantiated as i2c devices on the
i2c bus, not of platform devices.

The of_platform bus and the platform bus are just different
implementations of a "dumb" bus (roughly: single address space mapped
somewhere into MMIO, no introspection), the "of" variant being more
convenient for devtree based probing.  There's no inherent reason they
can't be merged, only a whole bunch of little fiddly reasons.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
