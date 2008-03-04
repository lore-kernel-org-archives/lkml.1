Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbYCDU6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbYCDU6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbYCDU5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:57:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49109 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754233AbYCDU5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:57:51 -0500
Date: Tue, 4 Mar 2008 15:57:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, <0x0007@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <200803041251.06725.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:

> On Tuesday 04 March 2008, Alan Stern wrote:
> > Dave, it seems to me that this must be an example of a race between the 
> > iaa watchdog timer expiring and end_unlink_async() running.  It's not 
> > good enough for end_unlink_async() to call iaa_watchdog_done(), because 
> > on an SMP system the timer may already have fired and the watchdog 
> > routine may be spinning on ehci->lock.
> 
> Right.
> 
> 
> > How about replacing the
> > 
> >         WARN_ON(!ehci->reclaim);
> 
> Or bettter yet, just removing it entirely.  ISTR doing that in some
> patches I've not yet sent for merging, and expect that's what my
> preferred fix will be ...

But removing the WARN_ON won't fix the problem.  The routine still
needs to exit immediately if ehci->reclaim isn't set, the root hub
isn't running, or the timer has been restarted.

Alan Stern

