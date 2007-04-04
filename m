Return-Path: <linux-kernel-owner+w=401wt.eu-S2992800AbXDDJzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992800AbXDDJzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992802AbXDDJzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:55:37 -0400
Received: from ozlabs.org ([203.10.76.45]:57101 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992800AbXDDJzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:55:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17939.30226.339390.709561@cargo.ozlabs.ibm.com>
Date: Wed, 4 Apr 2007 19:55:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070404074736.GA3440@flint.arm.linux.org.uk>
References: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<20070403.165518.55726194.davem@davemloft.net>
	<20070404021924.71e87580@the-village.bc.nu>
	<20070403.182125.77058566.davem@davemloft.net>
	<20070404074736.GA3440@flint.arm.linux.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King writes:

> FACT: you can only have one struct console with one name.

That could be solved by having the struct console at the generic
serial driver level rather than in the individual port drivers.

> FACT: there is no way to know at any particular driver registration time
>  how many "generic" serial ports will be available - as required for the
>  chardev and tty layers.

I think the thing that davem and I have in common is that we have a
data structure that the firmware gives us that (at least) enumerates
all of the on-board serial ports for us, thus we *can* know very early
in the boot process how many "generic" serial ports will be available.

> There are very real issues that need fixing deep within the kernel
> before you can even think about the possibility of *PROPERLY* supporting
> all serial ports beneath one namespace.

I don't actually want to do that; I'm perfectly happy for various
kinds of plug-in cards to each have their own namespace.  If you're
plugging in a Cyclades card for instance I think it's quite reasonable
for the ports to be named /dev/ttyCn.

It's the built-in serial ports on the motherboard where I think the
user should not have to know what sort of chip was used to implement
the serial port.  We don't require users to know whether the
manufacturer used an 8250 or a 16450 or a 16550, so why should it
matter if the manufacturer used an 8530?

BTW, are you still maintaining the serial layer?

Paul.
