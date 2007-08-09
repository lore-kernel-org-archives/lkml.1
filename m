Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbXHIUAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbXHIUAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXHIUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:00:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50718 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754288AbXHIUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:00:17 -0400
Date: Thu, 9 Aug 2007 16:00:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Zwell <dzwell@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       David Brownell <david-b@pacbell.net>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1: USB hard disk broken
In-Reply-To: <46BB47C9.3030609@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708091558260.4244-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Dan Zwell wrote:

> Oliver Neukum wrote:
> > Am Sonntag 05 August 2007 schrieb Tino Keitel:
> >> On Thu, Jul 26, 2007 at 10:06:40 +0200, Oliver Neukum wrote:
> >>> Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> >>>> On Wed, Jul 25, 2007 at 10:24:36 +0200, Oliver Neukum wrote:
> >>>>> Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> >>>>>> Hi,
> >>>>>>
> >>>>>> I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
> >>>>>> disk went mad.
> >>>> [...]
> >>>>
> >>>>> Please recompile with CONFIG_USB_DEBUG set.
> >>>>>
> >> I tried again -rc1 without USB_DEBUG, and was able to reproduce the
> >> bug 2 times. At the second time, the kernel log shows this:
> >>
> >> 2007-08-05_10:30:27.75572 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterli
> >> st error 0/-121
> >> 2007-08-05_10:30:27.86576 kern.info: usb 1-6: reset high speed USB device using ehci_hcd and address 5
> >> 2007-08-05_10:30:55.95293 kern.info: usb 1-6: USB disconnect, address 5
> >> 2007-08-05_10:30:55.95300 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error -108/-108
> > 
> > David, does this error say anything to you?
> > 
> > 	Regards
> > 		Oliver
> 
> Hi,
> 
> I just completed a git bisect, and commit 
> 8dfe4b14869fd185ca25ee88b02ada58a3005eaf was the commit that introduced 
> this problem. This is "usb-storage: implement autosuspend". I don't 
> think there have been many changes in drivers/usb since I last verified 
> this problem, so I'm pretty sure this is still happening in the latest 
> kernel.
> 
> The first thing I am going to do is pull the latest sources, attempt to 
> revert this patch, and see whether the kernel compiles and works 
> properly with my USB hard drive. Please let me know of anything I can do 
> to help.

What makes you think the problem you see is the same as the one 
described by Tino?  Do you get the "scatterlist error 0/-121" line in 
your log?

Please provide a dmesg log showing your problem with CONFIG_USB_DEBUG 
enabled.

Alan Stern

