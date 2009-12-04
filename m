Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZLDPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZLDPrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZLDPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:47:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43415 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160AbZLDPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:47:30 -0500
Date: Fri, 4 Dec 2009 10:47:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912041323.00799.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912041041370.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Ondrej Zary wrote:

> > Furthermore, the patch shows that the second-to-last argument to
> > usb_fill_bulk_urb() -- the completion function -- is NULL.  That is
> > strictly illegal and it should have caused an oops as soon as the URB
> > was used.
> 
> Thanks for catching this. usbmon showed no ACK packets so it didn't work
> at all. The device did not care. It started to work after adding a
> complete function.

What started to work?  If you don't send any ACK packets, it doesn't 
make any difference whether the completion function is set or not.


> Seems that -EPIPE is returned only after the device is disconnected. Adding a 
> check for -EPIPE to usbtouch_irq() and not submitting the urb again seems to 
> fix the problem!

Fix which problem?  The unending resubmissions or the oops in ehci-hcd?

BTW, does the touchscreen run at high speed or at full speed?

Alan Stern

