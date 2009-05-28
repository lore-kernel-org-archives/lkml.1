Return-Path: <linux-kernel-owner+w=401wt.eu-S1759685AbZE1IOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685AbZE1IOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZE1IOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:14:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:52493 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbZE1IOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:14:33 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>, Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
In-Reply-To: <20090527192909.GA32398@flint.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	 <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
	 <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk>
	 <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
	 <20090527192909.GA32398@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:10:58 +1000
Message-Id: <1243498258.3171.166.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 20:29 +0100, Russell King wrote:
> 
> 
> Bus width?  Register offset spacing?  SMC LED configuration?  Whether
> to use the hardware wait signal from the SMC?

Yes. Anything. Basically just a bunch of named properties with
arbitrary content in the nodes for the various devices.
  
> If you're going to say yes to all that, I'm going to start asking how
> you cope with verifying that the data for ethernet driver A doesn't
> get accidentally used for ethernet driver B.

I'm not sure about the question. If it's about identifying which
instance of a device is using the data, it's basically easy since
you used that device-node to create the device in the kernel in
the first place, so you just stick that node pointer into the
achdata as we do on powerpc and can use it to retrieve all the
properties.

If you are talking about different drivers for the same device,
well we try to define bindings such that they describe the hardware
itself in a way that is reasonably agnostic to whatever driver will be
used... 

> I assume you have some kind of compiler, which needs a set of
> specification files to tell it what's required for each driver which
> is OF compatible. If not, I can see no way for OF trees to ever be
> safe and correct.

No, the format at boot time is a flattened tree of nodes with arbitrary
named nodes containing other nodes and named properties (names are
ASCII) and properties have arbitrary binary content.

_Bindings_ define what to put in these things for various bus and device
types, and we do have a compiler, dtc, that goes from a C-like textual
representation and generates the blob.

It makes it easy to create properties that contains strings, numbers,
phandles (references to other nodes), etc...

Cheers,
Ben.


