Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYDDEvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYDDEvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYDDEu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:50:59 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:26634
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYDDEu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:50:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgAANBQ9Ud8qMuH/2dsb2JhbAAIrA8
X-IronPort-AV: E=Sophos;i="4.25,602,1199631600"; 
   d="scan'208";a="311496795"
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0804032014190.20532@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net>
	 <200711301040.54777.david-b@pacbell.net>
	 <20071130211332.49a21a6b@hyperion.delvare>
	 <200711301259.22666.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
	 <1207277135.4082.37.camel@moss.renham>
	 <Pine.LNX.4.64.0804032014190.20532@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 04 Apr 2008 15:57:56 +1100
Message-Id: <1207285076.4082.75.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 20:33 -0700, Trent Piepho wrote:

> Always too slow posting my patches.  I wrote this two months ago when there
> wasn't anything else.

I've got something similar myself; mine's more complex, handles and
reports IRQs but isn't near releasable.  Happens :-)

> 
> A char device allows better permissions and could be more efficient, if one
> really wants to do extensive control of gpio lines from userspace.  I can see
> how it might be preferrable in some instances.
> 
> The nice thing about sysfs is that you don't need any extra software to
> interact with it.  It's very convienent when you're just trying to debug the
> gpio driver you're writing or verify that the gpio lines you just connected
> are doing things.  It's also nice to be able to say something like:
> # run these commands to un-write protect flash
> echo out > /sys/class/gpio/MPC85XX:5/direction
> echo 1 > /sys/class/gpio/MPC85XX:5/value
> 
simple_gpio allows
echo "O1" > /dev/gpioN
to do what you've got above, no extra points there ;-)

> Instead of a complicated process that includes directions for creating the
> correct device file, compiling a program that will set gpio lines, downloading
> said program's source, and so on.

Creating the device file is largely mdev/udev's job, most people don't
have to worry about it.

As I mentioned before (and in my review of simple_gpio) I really like
the idea of having labels attached to the gpio numbers in some way; as
it stands I see that as simple_gpio's only major weakness.

David, you're kinda the gatekeeper here; any input from you on which
approach is to be preferred, essential features etc?

--Ben.

