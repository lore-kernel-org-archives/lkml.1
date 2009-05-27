Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZE0Ub1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZE0Ub1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZE0UbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:31:16 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:52026 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752350AbZE0UbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:31:15 -0400
Date: Wed, 27 May 2009 22:19:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527201951.GF30039@game.jcrosoft.org>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 11749891428607896348
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are two issues that keep the of_platform and platform busses
> separate.  They aren't show stoppers, but they reflect the current
> state.
> 
> 1) Source of data: a platform_device carries a pdata structure with it
> to describe the hardware.  An of_device carries a device_node pointer.
>  Before dropping of_platform bus, a mechanism needs to be in place to
> add hooks for translating the device tree data into a pdata structure
> for each platform device.
> 
> 2) Driver binding mechanism:  device tree nodes usually have a
> "compatible" property which is a list of strings.  The first string
> describes exactly what the device is (ie. "atmel,24c08") and an
> optional list of other devices which it is register interface
> backwards compatible with.  The intent is that newer devices can claim
> compatibility with older ones so that existing device drivers will
> work without needing to be told the new device name.  However, it
> leaves the option when a device errata or something similar raises
> it's ugly head, a driver can still get information about the exact
> device name and apply the appropriate workarounds.  Driver probing
> should walk the list and give preference to higher priority compatible
> values.  of_platform bus does this, but I cannot think of a clean way
> to do the same thing with the platform bus.
> 
> One option that has been suggested (more than once) is to make the
> adapter code an of_platform_driver which translates the device tree
> data and then registers the appropriate platform_devices.  This neatly
> solves the problem, but I don't like the overhead involved in
> registering 2 struct devices with the kernel for every device node in
> the device tree.
but simplify the dev and maintaining is also an important goal.

Have to duplicated ressource handling via ifdef in every drivers is also an
overhead which need to be avoided

Best Regards,
J.
