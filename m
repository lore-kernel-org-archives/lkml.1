Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZE1KlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZE1KlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZE1KlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:41:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55687 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZE1KlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:41:10 -0400
Date: Thu, 28 May 2009 11:34:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, scottwood@freescale.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       timur@freescale.com, yuan-bo.ye@motorola.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528103421.GC14789@n2100.arm.linux.org.uk>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> <20090528.025739.16559619.davem@davemloft.net> <1243505493.5573.29.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243505493.5573.29.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 08:11:33PM +1000, Benjamin Herrenschmidt wrote:
> Well, that example is interesting because you may not want the
> transceiver to be a child of the UART :-) The tree hierachy is mostly
> about addressing, and addressing below a UART doesn't mean much.
> 
> So if the transceiver has a bunch of MMIO registers, it might be better
> off located elsewhere, and have the UART have a "fir-transceiver"
> property with a phandle to the actual device...

IrDA transceivers do not have MMIO registers.  Transceivers are an IR
LED, an IR phototransitor and receiver circuitry.  They're typically
9 pin devices with power, ground, transmit, receive and a bunch of
control signals.

These control signals end up connected to some random GPIO pins or
FPGA or some other device which has some free IO lines in the platform.

These control signals need to be controlled with reference to the IrDA
driver, sometimes with tight timing constraints (particularly when
switching between SIR and FIR modes.)

> But yes, I definitely agree, it's flexible enough for a lot of that
> stuff. Where things get tricky is to express "methods" rather than just
> relationships. This is where x86 loses big time with ACPI, Apple lost
> with their platform functions in OF properties, and appart from having a
> real OF implementation under the hood that is kept alive along with the
> kernel to call in, the tree doesn't provide a simple solution.
> 
> However, it doesn't either invalidate existing solutions based on
> function pointers into the platform code... it might even make it nicer
> by naming those functions into some kind of directory where they can be
> registered by the platform code and "named" by a property in the node,
> though I tend to prefer the approach of having a property with a phandle
> to a node that is a pseudo-device ("power-control") or so, which has its
> own driver providing the methods.

The kind of reply I was hoping to get to my email was something more
along these lines - an informed view giving an idea how some of these
issues would be addressed with an OF device tree.

I can see how the named functions/directory would work - that seems to
be relatively simple and straight forward.

However, the pseudo-device approach I'm less clear about.  With a separate
driver for the "power control" pseudo-device, how would you communicate
the state information down to that driver?

I am equating OF devices and drivers too much with the struct device and
struct driver model, which sounds like it's not the best thing to do with
OF.
