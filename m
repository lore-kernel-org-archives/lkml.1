Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZE1DFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZE1DFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZE1DFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:05:45 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39476 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZE1DFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:05:45 -0400
Date: Thu, 28 May 2009 13:04:30 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528030430.GE1464@yookeroo.seuss>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Jon Smirl <jonsmirl@gmail.com>,
	Scott Wood <scottwood@freescale.com>,
	Janboe Ye <yuan-bo.ye@motorola.com>,
	Timur Tabi <timur@freescale.com>
References: <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com> <20090527201951.GF30039@game.jcrosoft.org> <fa686aa40905271354y50b9583cp9f53c35354edc285@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40905271354y50b9583cp9f53c35354edc285@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:54:10PM -0600, Grant Likely wrote:
> On Wed, May 27, 2009 at 2:19 PM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> >> One option that has been suggested (more than once) is to make the
> >> adapter code an of_platform_driver which translates the device tree
> >> data and then registers the appropriate platform_devices.  This neatly
> >> solves the problem, but I don't like the overhead involved in
> >> registering 2 struct devices with the kernel for every device node in
> >> the device tree.
> > but simplify the dev and maintaining is also an important goal.
> >
> > Have to duplicated ressource handling via ifdef in every drivers is also an
> > overhead which need to be avoided
> 
> agreed.  I don't have a best of both worlds answer here.

I do.  As intimated other places in this thread, I think the right
approach is to register constructor functions that will be used during
boot to traverse the OF devtree and instantiate platform devices (or
other device types in some cases, e.g. i2c).  The driver will then
bind to the platform device this created.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
