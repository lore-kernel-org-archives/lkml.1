Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYKEQN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYKEQN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYKEQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:13:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34020 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753786AbYKEQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:13:43 -0500
Date: Wed, 5 Nov 2008 11:13:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081104215829.GA2880@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811051102010.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Norbert Preining wrote:

> On Di, 04 Nov 2008, Alan Stern wrote:
> > > > If you can't boot with the modem off, then try this instead: Unload 
> > > > ehci-hcd, uhci-hcd, and ohci-hcd, then start up usbmon (copy the 0u 
> > > > file) and reload whichever driver the modem attaches to.
> 
> Ok, here it is. Booted with init=/bin/bash, no modules loaded, mounted
> /sys and debugfs, cat u0 > usbmon.txt. Then load uhci-hcd, then load hso
> modules.
> 
> Finally, kill the cat process.
> 
> Output is the attached usmon.txt file. 

Well, this is a little odd.  The trace shows the modem was detected and
enumerated correctly.  But there's nothing corresponding to when you
loaded the hso driver.  In fact, there's nothing after uhci-hcd 
finished starting up and the unconnected root hubs were suspended.

Did you look in /proc/bus/usb/devices at this point?  And what about
the files in /sys/bus/usb/drivers/hso/?

This suggests the problem may lie in the hso driver itself, or in a
failure to bind the driver to the device.

Alan Stern

