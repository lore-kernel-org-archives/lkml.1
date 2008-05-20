Return-Path: <linux-kernel-owner+w=401wt.eu-S935145AbYETPgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145AbYETPgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933746AbYETPb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:31:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46447 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934513AbYETPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:31:57 -0400
Date: Tue, 20 May 2008 11:31:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <nico@cam.org>
Subject: Re: [PATCH] Re: [Bug #10713] ehci splatter in 2.6.26-rc2
In-Reply-To: <20080520145948.GB23368@xi.wantstofly.org>
Message-ID: <Pine.LNX.4.44L0.0805201127520.2114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Lennert Buytenhek wrote:

> Well.  I just re-tested it a couple more times to be sure, and the
> "hcd->has_tt = 1;" line does make all the difference in the world when
> it comes to getting oopses on plugging in low speed USB devices on this
> board.  So if you don't understand what's going on then I guess I don't
> either.
> 
> 
> > That has_tt flag isn't used anywhere in ehci-hcd (it is only 
> > ever set, never read), and the only place it is used in usbcore is for 
> > adjusting the root hub's device descriptor.
> 
> Maybe this code in drivers/usb/core/hub.c has something to do with
> it?
> 
>         switch (hdev->descriptor.bDeviceProtocol) {
>                 case 0:
>                         break;
>                 case 1:
>                         dev_dbg(hub_dev, "Single TT\n");
>                         hub->tt.hub = hdev;
>                         break;
>                 case 2:
>                         ret = usb_set_interface(hdev, 0, 1);
>                         if (ret == 0) {
>                                 dev_dbg(hub_dev, "TT per port\n");
>                                 hub->tt.multi = 1;
>                         } else
>                                 dev_err(hub_dev, "Using single TT (err %d)\n",
>                                         ret);
>                         hub->tt.hub = hdev;
>                         break;
>                 default:
>                         dev_dbg(hub_dev, "Unrecognized hub protocol %d\n",
>                                 hdev->descriptor.bDeviceProtocol);
>                         break;
>         }

That must be it.  This code base is getting too large to keep in a 
single mind...

Looks like you should submit your patch.

Alan Stern


