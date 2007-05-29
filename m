Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXE2RzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXE2RzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 13:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbXE2RzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 13:55:12 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbXE2RzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 13:55:10 -0400
Date: Tue, 29 May 2007 10:54:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression: USB is nfg after suspend/resume(RAM) cycle on Intel
 chipset
In-Reply-To: <465C64D1.3030604@rtr.ca>
Message-ID: <alpine.LFD.0.98.0705291048020.26602@woody.linux-foundation.org>
References: <465C566E.4030009@rtr.ca> <alpine.LFD.0.98.0705290945520.26602@woody.linux-foundation.org>
 <465C608E.3040303@rtr.ca> <465C64D1.3030604@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Mark Lord wrote:
> 
> Okay, just to make it trivial,
> I've narrowed it down to only this commit from Alan Stern:
> 
> 7ed92f1a149dddc3cb537ccd7441e98adac12c3e USB: make the autosuspend workqueue
> thread freezable

Heh. Have I mentioned how much I *hate* those kernel threads being frozen?

Just for fun, could you try if the patch that just rips out the freezer 
calls from the STR code just fixes the problem too (instead of reverting 
that commit?)

It was done by Matthew Garrett <mjg59@srcf.ucam.org>, and you should be 
able to find it in the kernel archives under the subject

	Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
	Message-ID: <20070527184402.GA21161@srcf.ucam.org>

and it would be interesting to hear if that just solves the problem for 
you too.

There's a different (but related to all the same freezer problems) patch 
by Rafael Wysocki <rjw@sisk.pl>:

	Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
	Message-Id: <200705291415.31970.rjw@sisk.pl>

which would also be worth trying out.

			Linus
