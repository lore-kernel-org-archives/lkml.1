Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYHFWfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYHFWfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYHFWey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:34:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752577AbYHFWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:34:53 -0400
Date: Wed, 6 Aug 2008 18:34:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <489A1C68.3000905@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0808061828010.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Simon Arlott wrote:

> > Doing the HCD initcalls last certainly ought to work.
> 
> Right - so then all that's needed is to move usb/ before most other things that 
> take a while to init, and it has some time to initialise usb devices in the 
> background.

Not exactly -- you should move most of usb/ forward so that it comes
before usb/host/.  Or alternatively move usb/host/ later so that it 
comes after the rest of usb/.

> > So what exactly do you recommend?
> 
> I'm not an expert on what can be done with the Makefile process, perhaps there's 
> an easier way to move things around based on a config option. If host init is 
> moved before device init for everyone, wouldn't there be too many side effects?

Doesn't the host init _already_ come before device init?  If host init 
were moved _after_ device init, I don't think there would be a lot of 
side effects.  But it's hard to be sure without trying it.

> Lack of a keyboard makes it impossible to do anything if the module fails to 
> load... as I understand it when the HCD init runs, any BIOS emulation stops?

That's right.  The host driver kicks the BIOS off the hardware.

> Although if HCD is a module too...
> 
> >> If even one device driver and the hcd is compiled in, they'd need to 
> >> wait for every USB device to finish init before the usbhid probe could complete.
> > 
> > What if usbhid is the one device driver that is compiled in?  :-)
> 
> That was the situation I was thinking of - surely that would be compiled in 
> if the HCDs were?

I noticed in your logs earlier that some of your USB drivers were 
compiled in and others weren't.  Maybe if _all_ of them were compiled 
in you wouldn't experience as much contention and the init delays would 
be shorter.

Alan Stern

