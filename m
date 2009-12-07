Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbZLGQB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbZLGQB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbZLGQB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:01:58 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40908 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932422AbZLGQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:01:57 -0500
Date: Mon, 7 Dec 2009 11:02:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912071607.38351.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912071056160.3064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Ondrej Zary wrote:

> Just tried another hub. Now there are two hubs connected to separate ports
> on the machine. Nexio is the only device connected to the "new" hub. No matter
> where I connect the device or the 2nd hub, it always appears on "Bus 001":

That's what is supposed to happen.  It sounds like the second hub works 
correctly and the first hub doesn't.  Try running the test described in 
my previous email with the second hub as well as with the first hub.

> The problem is still the same. Removing the module causes devices on the other
> hub to fail.

(Presumably you mean the failure occurs if you leave out the code to
prevent resubmits for -ESTALL from the touchscreen driver.)

It doesn't cause the devices to fail; it causes the ehci-hcd driver to
fail.

> Disconnecting the touchscreen first and then removing the module does not
> cause any problems (with either of the hubs) - so it must be a software
> problem.

Yes, we still need to track it down.  Which means we need to find out 
when that pointer is getting set to NULL.

Alan Stern

