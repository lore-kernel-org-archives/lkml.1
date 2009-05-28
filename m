Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbZE1Ms2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbZE1Ms2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbZE1MsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:48:21 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54608 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZE1MsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:48:20 -0400
Date: Thu, 28 May 2009 22:48:17 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528124817.GB4565@yookeroo.seuss>
Mail-Followup-To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> <20090528.025739.16559619.davem@davemloft.net> <gvlvcs$ub5$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gvlvcs$ub5$1@ger.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 12:17:32PM +0000, Dmitry Eremin-Solenikov wrote:
> David Miller wrote:
> 
> > From: Russell King - ARM Linux
> > <linux@arm.linux.org.uk> Date: Thu, 28 May 2009
> > 10:15:13 +0100
> > 
> >> For example, how would an IrDA transceiver be expressed in OF?
> > 
> > As a child device node of the IRDA device, with associated properties.
> > 
> > You can express _ANYTHING_ using the OF device tree.  It is not even
> > something to discuss, it's flexible enough.
> 
> Hmmm. How to express the following situation:
> On one of my platforms (sharp tosa) the backlight controller
> is separated into two parts: one sitting on SPI, one on the I2C.
> The tricky part is that the I2C part is only available when some
> of registers of SPI part are programmed in a specific way.

Put nodes under both the SPI and I2C busses, they have properties with
phandles to refer to each other (could be one way or both depending on
needs).  Sprinkle with any additional information properties as
necessary.  Your driver (in the broad sense, rather than the "struct
device_driver" sense) binds both devices and does what it needs to do.

The I2C part should possibly have a status property with value
"disabled" to indicate that it's not usable, until something activates
it (in this case the other part of the driver frobbing the SPI side).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
