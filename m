Return-Path: <linux-kernel-owner+w=401wt.eu-S1765794AbXE2UMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765794AbXE2UMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbXE2UMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:12:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51644 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751120AbXE2UMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:12:13 -0400
Date: Tue, 29 May 2007 16:12:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <465C7AEB.7030304@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0705291600430.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Mark Lord wrote:

> >> Okay, just to make it trivial,
> >> I've narrowed it down to only this commit from Alan Stern:
> >>
> >> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue thread freezable
> > 
> > I'm a little surprised; I would have expected the other patch to be the 
> > one responsible.  Are you sure you got the right one?
> 
> Absolutely, 100% sure.

In fact, looking back at things I suspect the real culprit was

6b157c9bf3bace6eeb4a973da63923ef24995cce USB: separate autosuspend from 
external suspend

The patch you identified merely makes the problem much more likely to
occur.  It causes both threads involved in the deadlock to be frozen
instead of just one of them, so when things get unfrozen the race is
poised to occur.

> I didn't re-break the kernel to do the alt-sysrq thing,
> but I did reapply the b0rken commit plus your new patch (below).

No need, it seems pretty clear that this was the problem.

> So far, so good with that combination, thanks.

You're welcome.  I'll send the patch on up the line...

Greg, the patch I sent Mark is for 2.6.22-rc3.  It's different from the
corresponding patch for the USB development tree because of intervening
changes.  How would you like to handle this?  Should I send you both
versions of the patch?

Alan Stern

