Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXECOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXECOqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXECOqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:46:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35791 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754355AbXECOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:46:18 -0400
Date: Thu, 3 May 2007 10:46:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <marcel@holtmann.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [BUG] usb/core/hub.c loops forever on resume
 from ram due to bluetooth
In-Reply-To: <4639E743.2080504@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0705031042340.3548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Mark Lord wrote:

> > If the code never gets stuck in a loop, then there's no need to check 
> > whether the loop is unbounded!  :-)
> 
> Yes, except here we know it does actually get stuck in a loop,
> and having unbounded loops in device-driver code is a known baddy.
> 
> One cannot predict perfectly exactly how devices will fail,
> but one can program defensively against them with simple precautions
> like limiting list traversals and the like.  :)
> 
> Sure, Marcel may eventually look at the bluetooth code and fix it
> to not get confused, but some other USB device may then show up
> in the future with similar issues.

I'd agree, except that the problem isn't in the bluetooth code.  And it
probably doesn't have anything in particular to do with the fact that this
is a bluetooth device; the TT code gets used with USB hubs only.  More
accurately, the code helps manage the TT embedded in a high-speed USB hub,
allowing the hub to communicate with a full- or low-speed USB device
plugged into it.

>  The messages are still there
> so we'll know about any future failure, but it won't just silently
> crash the machine on resume this way.
> 
> Remember, resume is a very tough operation to debug at the best
> of times, so adding some harmless robustness to the more troublesome
> drives is a very Good Thing(tm) here.

Alan Stern

