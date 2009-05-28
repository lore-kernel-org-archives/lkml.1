Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZE1KOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZE1KOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZE1KNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:13:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:36854 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbZE1KNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:13:52 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: linux@arm.linux.org.uk, scottwood@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       timur@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090528.025739.16559619.davem@davemloft.net>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <1243496236.3171.140.camel@pasglop>
	 <20090528091513.GA14789@n2100.arm.linux.org.uk>
	 <20090528.025739.16559619.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 28 May 2009 20:11:33 +1000
Message-Id: <1243505493.5573.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 02:57 -0700, David Miller wrote:
> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Date: Thu, 28 May 2009 10:15:13 +0100
> 
> > For example, how would an IrDA transceiver be expressed in OF?
> 
> As a child device node of the IRDA device, with associated
> properties.
> 
> You can express _ANYTHING_ using the OF device tree.  It is
> not even something to discuss, it's flexible enough.

Well, that example is interesting because you may not want the
transceiver to be a child of the UART :-) The tree hierachy is mostly
about addressing, and addressing below a UART doesn't mean much.

So if the transceiver has a bunch of MMIO registers, it might be better
off located elsewhere, and have the UART have a "fir-transceiver"
property with a phandle to the actual device...

But yes, I definitely agree, it's flexible enough for a lot of that
stuff. Where things get tricky is to express "methods" rather than just
relationships. This is where x86 loses big time with ACPI, Apple lost
with their platform functions in OF properties, and appart from having a
real OF implementation under the hood that is kept alive along with the
kernel to call in, the tree doesn't provide a simple solution.

However, it doesn't either invalidate existing solutions based on
function pointers into the platform code... it might even make it nicer
by naming those functions into some kind of directory where they can be
registered by the platform code and "named" by a property in the node,
though I tend to prefer the approach of having a property with a phandle
to a node that is a pseudo-device ("power-control") or so, which has its
own driver providing the methods.

The possibilities are endless. _BUT_ it does require some careful
thinking to get things right. To that extent, I do agree with Russell
that rather than a "violent" conversion, ARM should first try things out
as an opt-in for a few platforms and see how it goes.

Cheers,
Ben.


