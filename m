Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZE1IBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZE1IBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbZE1IBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:01:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:55467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbZE1IBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:01:05 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
In-Reply-To: <fa686aa40905271354y50b9583cp9f53c35354edc285@mail.gmail.com>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
	 <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
	 <20090527192116.GA31110@n2100.arm.linux.org.uk>
	 <20090527193927.GD30039@game.jcrosoft.org>
	 <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
	 <20090527201951.GF30039@game.jcrosoft.org>
	 <fa686aa40905271354y50b9583cp9f53c35354edc285@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 17:58:41 +1000
Message-Id: <1243497521.3171.161.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 14:54 -0600, Grant Likely wrote:
> > Have to duplicated ressource handling via ifdef in every drivers is
> also an
> > overhead which need to be avoided
> 
> agreed.  I don't have a best of both worlds answer here.

Right and I don't advocate changing existing perfectly working platform
drivers, I think having wrappers to create them is fine.

In fact, I've been thinking for a long time about doing something like
that: Have those wrappers be registered via a standard OF set of match
strings for bus types and device types.

Then we can have a single loop that walks the tree, invoke those
"constructors" that return a struct device * (whatever the device
type that was actually created, could have been platform_device,
pci_dev, amba_device, etc...). It also passes them the parent device *

That way, all devices are instanciated from the DT -and- the topology
in sysfs preserves the topology in the device-tree (ie, parent/child
relationships are preserved).

Cheers,
Ben.


