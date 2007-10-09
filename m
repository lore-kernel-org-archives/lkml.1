Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbXJIFMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbXJIFMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXJIFL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:11:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:36625 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbXJIFLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:11:55 -0400
Subject: Re: OHCI root_port_reset() deadly loop...
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071008.214727.48799757.davem@davemloft.net>
References: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <20071008.204236.92016616.davem@davemloft.net>
	 <20071009043909.GA4940@kroah.com>
	 <20071008.214727.48799757.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 15:11:41 +1000
Message-Id: <1191906701.6355.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 21:47 -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Mon, 8 Oct 2007 21:39:09 -0700
> 
> > No, nothing cute in udev itself, but it seems that all distros that I
> > know of have a "load these modules now" type setting in their init
> > scripts that can be used here.
> > 
> > I can't think of a way to enforce this load order on the modules
> > themselves due to the fact that OHCI might not even be needed for EHCI
> > devices on UHCI (Intel) based chipsets :(
> > 
> > Can anyone else?
> 
> The three modules perhaps should be a bundle of whatever ones you have
> enabled, and internally we can dispatch the initialization to occur in
> the correct order from a top-level module_init().
> 
> If the devices need to be initialized in a certain order in a
> situation like this, it really seems like it is the kernel's job to
> enforce it.

Is the problem strictly an ordering problem or just a race ? In the
later case, maybe some better arbitration by the USB core to make
sure things are quiescent or in a known state when letting a new HCD
register might help ?

Ben.


