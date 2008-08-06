Return-Path: <linux-kernel-owner+w=401wt.eu-S1422715AbYHFU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422715AbYHFU0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYHFU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:26:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60625 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756840AbYHFU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:26:29 -0400
Date: Wed, 6 Aug 2008 16:26:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <489A0467.1060607@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808061616450.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Simon Arlott wrote:

> No, by adding a 5 second delay you're intending for the device driver initcalls 
> to complete within that 5 seconds. If they take too long then the last one 
> blocks everything (I realise that's ridiculous, these initcalls take <1ms when 
> there are no devices yet). The best way to do is to make the driver initcalls 
> before the host ones, like you suggested.

Doing the HCD initcalls last certainly ought to work.

> > "it'll still have to wait..."  If by "it" you mean the initcall
> > thread, you're wrong.  If by "it" you mean the user, you still aren't
> > necessarily correct; the user can do plenty of other things while
> > waiting for USB devices to initialize.
> 
> Assuming userspace doesn't wait for all devices to settle and appear in /dev etc. 
> before continuing.

Whatever that involves...  /dev never truly settles; it's always 
possible to plug in a new device or remove an old one.

> > I suppose you could make the hub_thread delay time a module parameter 
> > for usbcore, defaulting to 0.  Then it could be set by just the people 
> > who want to use it -- many (most?) people keep their drivers in 
> > modules, and it wouldn't do them any good.
> 
> It really needs to have hcd initcalls done very early so that device init 

Please stop using the word "it" with no antecedent!  Do you mean "we"?

> has the rest of the (kernel and userspace) boot process to complete in the 
> background. This is negated by having device drivers initialised immediately 
> afterwards. Re-ordering initcalls and doing more of the init process 
> asynchronously is likely to expose bugs and cause inconsistent device order 
> on some systems, so if the makefile mess could be reduced then it can be a 
> Kconfig option.

So what exactly do you recommend?

> How many people have *all* their USB components (hcd, drivers) as modules?

All the major distributions do, as far as I know.  (I haven't actually 
checked them all to be certain.)

> What do they do with their USB keyboards in the period between init and module 
> load?

Probably nothing.  What do you do on your keyboard while waiting for
system initialization to complete?

> If even one device driver and the hcd is compiled in, they'd need to 
> wait for every USB device to finish init before the usbhid probe could complete.

What if usbhid is the one device driver that is compiled in?  :-)

Alan Stern

