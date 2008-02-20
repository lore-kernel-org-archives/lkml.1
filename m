Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbYBTVRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbYBTVRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765583AbYBTVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:16:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55414 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764368AbYBTVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:16:16 -0500
Date: Wed, 20 Feb 2008 16:16:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <47BC8E9D.8080309@tomt.net>
Message-ID: <Pine.LNX.4.44L0.0802201606430.7212-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Andre Tomt wrote:

> David Brownell wrote:
> > On Tuesday 19 February 2008, Andre Tomt wrote:
> >>> Can you try this diagnostic patch, to see if it reports any messages
> >>> about IAA and/or IAAD oddities?  There's surely a quick workaround
> >>> for this, but I'd rather understand the root cause before patching.
> >> Doesn't seem to have triggered anything. dmesg attached in case I missed 
> >> anything.
> > 
> > You don't seem to have enabled CONFIG_USB_DEBUG, as the patch instructions
> > say is needed to get such diagnostics ... I can tell because the startup
> > messages from USB are pretty minimal.  (See appended, vs what you sent...)
> > 
> > Please try again with USB debugging enabled.
> 
> Argh, silly me. Here you go (attached). It has not crashed yet with the 
> patch though.

You know, Dave, seeing all those

> ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021

lines in the log brings up some ideas that have been percolating in my 
mind for a while.  They have to do with the possibility of a race 
between the watchdog routine and assertion of IAA.

In fact, if the timing comes out just wrong then it's possible (on SMP
systems) for an IAA interrupt to arrive when the watchdog
routine has already started running.  Then end_unlink_async() might get 
called right at the start of a new IAA cycle, or when the reclaim list 
is empty.

Alan Stern

