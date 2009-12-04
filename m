Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZLDTer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZLDTer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZLDTeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:34:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42663 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755093AbZLDTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:34:45 -0500
Date: Fri, 4 Dec 2009 14:34:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912042017.36459.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912041427550.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Ondrej Zary wrote:

> Just found why it was sometimes hard to reproduce a problem. Sometimes the
> devices are controlled by uhci_hcd and sometimes by ehci_hcd. It seems to
> be random and can change on every reboot.

It shouldn't change.  The hub you plug into (the D-Link hub) should
always be controlled by ehci-hcd.  Can you post a dmesg log showing
what happens on bootup for a case where the hub ends up under uhci-hcd?

> With uhci_hcd, rmmod works fine. With ehci_hcd, rmmod hangs the bus - all
> urbs fail with -ENOENT:
> f67265e8 1428021080 S Bi:1:009:2 -115 128 <
> f67265e8 1431508327 C Bi:1:009:2 -108 0
> f6726718 1458252464 S Co:1:007:0 s 40 09 0001 0000 0000 0
> f6726718 1463261404 C Co:1:007:0 -2 0
> f6726978 1463261428 S Co:1:002:0 s 23 08 0070 0001 0000 0
> f6726718 1463261509 S Co:1:007:0 s 40 00 0000 0000 0000 0
> f6726978 1464273397 C Co:1:002:0 -2 0
> f6726718 1468273397 C Co:1:007:0 -2 0

This may be a bug in ehci-hcd, a bug in your EHCI hardware, or a bug in
the hub.  Can you try using a different high-speed hub to see if it
makes any difference?

Alan Stern

