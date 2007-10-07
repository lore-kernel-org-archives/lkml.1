Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbXJGHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbXJGHwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 03:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXJGHwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 03:52:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46437
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbXJGHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 03:52:00 -0400
Date: Sun, 07 Oct 2007 00:51:56 -0700 (PDT)
Message-Id: <20071007.005156.85395415.davem@davemloft.net>
To: david-b@pacbell.net
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071006.235358.104048815.davem@davemloft.net>
	<20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Sun, 07 Oct 2007 00:31:41 -0700

> Is this SPARC, or is ACPI potentially in play?  PCI, or non-PCI?

It's sparc64 on PCI.

> Are the other ports still behaving?  Is EHCI maybe trying to switch
> ownership of that port?  Is maybe the (newish) autosuspend stuff
> kicking in?

I wouldn't know, the machine hangs and doesn't get any further.

> Patches accepted.  :)

I'm 700 patches deep with an additionally large backlog of
patches to apply for the networking and sparc64 tree.

I don't have the time, which is why I reported the problem
to the OHCI maintainer instead of letting it slip through
the cracks.

> Since the PRS bit is specified as "write one", with writing zero
> as no-effect (since the rest is hardware-timed), the only recovery
> procedure might involve resetting the whole controller.  Messy,
> and not something the usb core has historically handled very well.

At a minimum you should exit the loop and print out a warning
messages and try to continue even without trying to reset the
whole controller if that will take some developer effort.

Anything is better than just hanging there forever.  Not every
user knows to hit ALT-SYSRQ then 'P' to get a register dump to
figure out why their computer stopped booting.

Every register polling loops, without exception, should have a limit
and exit with an error indication when that limit is reached.  It
will never hang someones machine, because although not this time, in
many cases these kinds of hangs are absolutely impossible to debug
(interrupts disabled, critical lock held, etc.)
