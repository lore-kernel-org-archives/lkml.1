Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZE1DG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZE1DG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZE1DFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:05:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39473 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZE1DFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:05:46 -0400
Date: Thu, 28 May 2009 13:02:33 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Timur Tabi <timur@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528030233.GD1464@yookeroo.seuss>
Mail-Followup-To: Robert Schwebel <r.schwebel@pengutronix.de>,
	Timur Tabi <timur@freescale.com>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	linux-kernel@vger.kernel.org, Janboe Ye <yuan-bo.ye@motorola.com>,
	linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527150527.GK6805@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 05:05:27PM +0200, Robert Schwebel wrote:
> On Wed, May 27, 2009 at 09:39:30AM -0500, Timur Tabi wrote:
[snip]
> - The whole concept is based on the assumption that bindings are defined
>   *once*, then never to be changed again. As this is not true (check
>   MPC5200 to find out what I mean), oftree wreckage is *the* main cause
>   of new kernels not working on old bootloaders any more. Is there a
>   solution of this problem? I have not seen a good idea how to avoid the
>   constant change in definitions.

That's true in the ideal, but doesn't break down completely in
reality.  Sure, you want to *aim* for a binding which never needs
updating, but in practice of course, you do need to change it.  When
you do, you end up with backwards compatibility code in the kernel or
the firmware or both to handle both "old" and "new" variants of the
device tree.  It's not perfect, but it still results in substantially
*less* accumulated cruft than we had before.

> - The oftree layering is fundamentally broken. We already have a sane
>   abstraction for arbitrary hardware in the kernel: platform devices.
>   Why not instanciate platform devices from a generic oftree core?

You're conflating the concept of the device tree structure with the
way we instantiate of_platform devices.  As Grant says, the actual
passed in device tree is just a data structure.

You're correct that the layering for the handling of the of_platform
bus and of_platform devices is fundmentally broken, although in
practice it works a lot less badly than it does in theory.  I've been
meaning to get around to replacing this with a saner structure (using
a table of constructor functions to instantiate platform devices or
others from the device tree information), but haven't had time yet.

> - Platform data makes it possible to store function pointers. There
>   is no equivalent to this concept in oftree-land.
> 
> oftree could be a great tool if these things would be resolved.
> Currently they are not, and in result, ARM just works and is easy,
> whereas on PowerPC systems people often spend more time working on
> binding stuff than on the actual functionality.

I think that was true in the early days when everyone was getting the
hang of the device tree.  It's becoming less and less true.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
