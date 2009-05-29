Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZE2JNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZE2JNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbZE2JNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:13:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:60362 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300AbZE2JNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:13:31 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090529075238.GC24565@pengutronix.de>
References: <4A1D6901.2090508@freescale.com>
	 <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <4A1D8FBA.6040802@freescale.com>
	 <20090527192909.GA32398@flint.arm.linux.org.uk>
	 <20090527205218.GA5591@sirena.org.uk>
	 <fa686aa40905271405pc2f1738gc8dd139f61a0e27@mail.gmail.com>
	 <20090528124307.GN22742@pengutronix.de>
	 <alpine.LFD.2.00.0905281457170.3397@localhost.localdomain>
	 <20090528150409.GO22742@pengutronix.de> <1243558274.17903.21.camel@pasglop>
	 <20090529075238.GC24565@pengutronix.de>
Content-Type: text/plain
Date: Fri, 29 May 2009 19:08:00 +1000
Message-Id: <1243588080.17903.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 09:52 +0200, Sascha Hauer wrote:
> 
> I don't mean bloated in terms of kbytes but bloated in terms of complex
> code used to parse the device tree. I more than once put information in
> the device tree and wondered where this information got lost on the way
> to the driver where I wanted to use it. Back on ARM I was very happy to
> just have a simple board file which is easier for me to understand and
> maintain.
> Of course this can be solved with /me learning more about the device
> tree, that's why I said 'for my taste'.

Well, the code to walk it is trivial since once 'expanded' we reproduce
the tree structure with pointers.

Now, the problem indeed is how do you get to your node from a driver,
and that's where we are making things easy on powerpc by sticking the
node pointer in the struct device itself.

Of course that needs to be populated properly. We have code in PCI to do
it that would need to be ported over for PCI stuff (but I recommend
waiting a bit as this code is currently different on ppc32 and ppc64, a
bit messy, and Kumar is currently working on cleaning that up and
unifying it), and when device are discovered and instanciated from the
DT in the first place, then this is naturally populated.

So I don't think this is a big issue, and the amount of code involved is
relatively small and self contained.

Cheers,
Ben.


