Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZHNILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZHNILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZHNILL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:11:11 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:35292
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbZHNILJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:11:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApYBALe4hEp8qNxw/2dsb2JhbAAI0n2EGQWBTQ
X-IronPort-AV: E=Sophos;i="4.43,379,1246809600"; 
   d="scan'208";a="551253645"
Subject: Re: GPIOLIB, GPIO_SYS and port-wide accesses
From: Ben Nizette <bn@niasdigital.com>
To: John Williams <john.williams@petalogix.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       David DeBonis <david.debonis@xilinx.com>,
       Michal Simek <michal.simek@petalogix.com>,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <1d3f23370908131701w50f2c550r312b14b2c7f2d12c@mail.gmail.com>
References: <1d3f23370908131701w50f2c550r312b14b2c7f2d12c@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 18:11:52 +1000
Message-Id: <1250237512.4033.135.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-08-14 at 10:01 +1000, John Williams wrote:
> Did anything ever come of that?

Nothing ever did, though others keep half-heartedly implementing the
same thing every few months.  They seem to disappear before it's
accepted though.

> 
> Per-bit access is pretty inflexible if you are driving a 7-segment
> display or 8-LED bar display, holding lots of file descriptors open
> etc, and lots of syscall overhead.
> 
> sysfs syntax like
> 
> $ echo "240-247" > export
> $ echo 255 > gpio240-247/direction  (8-bit binary mask - output)
> $ echo 255 > gpio240-247/value (all ones)
> 

The first line, to some eyes, would violate the one-value-per-attribute
thing sysfs insists on, but sure there are ways to do this.

> would be reasonably friendly, obviously the underlying gpiolib would
> have to have some notion of coupled ports.

The main stumbling block is that implementers forget that gpiolib is
just one implementation of the gpio api - any solution should

1) define accessor functions for multiple bits in the gpio api
2) implement these in gpiolib and other gpio api implementations (I
think the other implementations at the moment are all just stubs anyway)
3) Get gpiolib to bunt requests to the gpiochip
4) Write support for each gpiochip which has this functionality

The other stumbling block is that this all depends on bitmasks of some
kind or other but there's no good reason to nail this to any particular
word size.  Sure most are 8- or 32-bit banks but we have to deal with
the weird ones too.  In particular, I've seen FPGA-implemented gpio
controllers with banks of many hundred GPIO.  Accommodating those will
take an amount of bit-fu.

Anyway, if anyone out there has the patience to stick around until a
solution is correct we'll get something useful for all I'm sure.

	--Ben.

