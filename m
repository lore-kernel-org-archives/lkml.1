Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZE1WWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZE1WWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZE1WW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:22:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:43999 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZE1WWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:22:25 -0400
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com>
References: <20090527175609.GB31861@flint.arm.linux.org.uk>
	 <1243496236.3171.140.camel@pasglop>
	 <20090528091513.GA14789@n2100.arm.linux.org.uk>
	 <20090528.025739.16559619.davem@davemloft.net> <gvlvcs$ub5$1@ger.gmane.org>
	 <fa686aa40905280713u2b3ef5fvbe3d58ccdb629b60@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 08:21:58 +1000
Message-Id: <1243549318.17903.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 08:13 -0600, Grant Likely wrote:
> Two nodes are used to describe the device and a "phandle" is used to
> link them.  A device driver probe could be triggered (bind) against
> the i2c half of the device and follow the phandle to get the rest of
> the description.

One thing I wouldn't do though is to put "phandle" in the property
name :-) Just call it spi-interface.

Now, that's an option. And it works to a certain extent. But I do
understand the need in general to provide "methods". It's something
we don't solve (but then we don't make it worse than it was before).

I think the cleanest option might be named methods in the device-tree
for example, a device can have an "enable-method" property and a
"clock-method" property. The names would use the usual convention
of "manuf,name" to avoid clashes and could be registered by the
platform.

Now, it -does- somewhat deviates from the moto that the DT should
only contain OS agnostic HW representations, but appart for having
a full blown OF with actual method calls in each nodes I don't
see a nicer way at this stage.

Now, the methods could then take "informations" from the target DT.

For example, one could have a generic "simple-gpio-enable" method that
can be used as "enable-method" anywhere, as long as the target device
contains also a "enable-gpio" property that points to the actual GPIO
(and maybe an "enable-delay" while at it).

IE. We can provide a collection of "simple" methods that handle
the easy cases in library code.

I'm very much against putting actual function pointers in the tree
though as Jon Smirl proposed.

Cheers,
Ben.

